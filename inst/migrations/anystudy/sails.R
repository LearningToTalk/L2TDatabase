# Add SAILS administrations and responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("readr")
source("inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Map from study to study number, from study/short research id to child-study
# id, from child-study id to research id
# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate, FullResearchID) %>%
  collect()



# Get SAILS responses
df_local_sails_data <- paths$sails %>%
  # need to specify col types so Participant_ID doesn't get converted to number
  read_csv() %>%
  rename(
    ShortResearchID = Participant_ID,
    SAILS_Dialect = Dialect,
    SAILS_EprimeFile = Eprime_Basename,
    SAILS_Completion = Date)



# Make sure the CochlearMatching kids have the correct Study name
cimatching_ids <- df_cds %>%
  filter(Study == "CochlearMatching") %>%
  getElement("ShortResearchID")

df_local_sails_data <- df_local_sails_data %>%
  mutate(Study = ifelse(ShortResearchID %in% cimatching_ids, "CochlearMatching", Study))

# Make a table of administrations by getting one row per eprime file
df_local_sails_admin <- df_local_sails_data %>%
  select(Study, ShortResearchID, SAILS_Dialect,
         SAILS_EprimeFile, SAILS_Completion) %>%
  distinct()

df_local_sails_admin %>% count(Study)

# Attach birthdates so we can compute age at task completion
df_local_sails_admin <- df_local_sails_admin %>%
  left_join(df_cds, c("Study", "ShortResearchID")) %>%
  mutate(
    SAILS_Age = chrono_age(Birthdate, SAILS_Completion),
    IDFromFile = str_replace(SAILS_EprimeFile, "SAILS_", ""))

# Check for children not found in database
df_local_sails_admin %>% filter(is.na(ChildStudyID))

# Count for repeated filenames
df_local_sails_admin %>%
  select(SAILS_Dialect, SAILS_EprimeFile, SAILS_Completion) %>%
  count(SAILS_EprimeFile) %>%
  filter(n != 1)

# Check for weird cases where id in filename doesn't match the FullResearchID
id_mismatch <- df_local_sails_admin %>% filter(IDFromFile != FullResearchID)
id_mismatch

# Keep just children in database where ID in filename matches database id
df_local_sails_admin <- df_local_sails_admin %>%
  anti_join(id_mismatch, by = "SAILS_EprimeFile") %>%
  select(-IDFromFile) %>%
  filter(!is.na(ChildStudyID)) %>%
  arrange(Study, ChildStudyID, SAILS_EprimeFile)


# Format administration rows to match database
df_remote_admin <- l2t_dl$SAILS_Admin %>%
  type_convert()

df_local_admin <- match_columns(df_local_sails_admin, df_remote_admin)

# Remove adminstrations already in database
rows_to_add <- df_local_admin %>%
  anti_join(df_remote_admin, by = c("ChildStudyID", "SAILS_Dialect", "SAILS_EprimeFile")) %>%
  arrange(ChildStudyID, SAILS_EprimeFile)
rows_to_add

# Preview who is being added
inner_join(df_local_sails_admin, type_convert(rows_to_add)) %>%
  select(Study, ShortResearchID, SAILS_EprimeFile) %>%
  as.data.frame() %>%
  arrange(Study, ShortResearchID)

# There should not be any repeated file names
stopifnot(length(rows_to_add$SAILS_EprimeFile) == n_distinct(rows_to_add$SAILS_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "SAILS_Admin", rows_to_add)
tbl(l2t, "SAILS_Admin")


## Find records that need to be updated

# Redownload the table
remote_sails_admins <- collect("SAILS_Admin" %from% l2t)

# Attach the database keys to latest data
admins_current_indices <- remote_sails_admins %>%
  select(ChildStudyID, SAILSID)

admins_latest_data <- df_local_admin %>%
  inner_join(admins_current_indices)  %>%
  arrange(SAILSID) %>%
  mutate(SAILS_Completion = format(SAILS_Completion))

# Keep just the columns in the latest data
remote_sails_admins <- match_columns(remote_sails_admins, admins_latest_data) %>%
  arrange(SAILSID)

# Preview changes with daff
library("daff")
daff <- diff_data(remote_sails_admins, admins_latest_data, context = 0)
render_diff(daff)

create_diff_table(admins_latest_data, remote_sails_admins, "SAILSID")
overwrite_rows_in_table(l2t, "SAILS_Admin", rows = admins_latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "SAILS_Admin", rows = admins_latest_data, preview = FALSE)



## Add trial-level data

# Attach local responses to remote administration records using the eprime
# filename, administration date and dialect
df_remote_admin <- collect("SAILS_Admin" %from% l2t) %>% type_convert
curr_responses <- l2t_dl$SAILS_Responses

df_remote_admin_with_local_responses <- df_remote_admin %>%
  inner_join(df_local_sails_data, by = c("SAILS_Dialect", "SAILS_EprimeFile", "SAILS_Completion")) %>%
  match_columns(curr_responses)

# Check for NAs
any(is.na(df_remote_admin_with_local_responses))
lapply(df_remote_admin_with_local_responses, unique)

# Which responses are missing
missing_responses <- df_remote_admin_with_local_responses %>%
  filter(is.na(Correct))
missing_responses

# Which administrations contain the missing reponses
df_remote_admin %>%
  inner_join(missing_responses)

# Remove duplicated rows
response_cols <- c("SAILSID", "Running", "Cycle", "Trial")
responses_to_add <- df_remote_admin_with_local_responses %>%
  anti_join(curr_responses, by = response_cols) %>%
  anti_join(missing_responses, response_cols) %>%
  arrange_(.dots = response_cols)
responses_to_add

append_rows_to_table(l2t, "SAILS_Responses", responses_to_add)



## Check for differences between local and remote data

# Redownload the table
remote_admin_data <- collect("SAILS_Admin" %from% l2t) %>% type_convert()
remote_response_data <- collect("SAILS_Responses" %from% l2t)

local_data <- df_local_sails_data %>%
  select(SAILS_EprimeFile, SAILS_Completion, SAILS_Dialect, Running:Correct) %>%
  arrange(SAILS_EprimeFile, Running, Trial)

remote_data <- remote_admin_data %>%
  left_join(remote_response_data) %>%
  select(SAILS_EprimeFile, SAILS_Completion, SAILS_Dialect, Running:Correct) %>%
  arrange(SAILS_EprimeFile, Running, Trial)

anti_join(local_data, remote_data)
anti_join(remote_data, local_data)

# Preview changes with daff. Will show changes needed to make the remote match
# the local data-set
library("daff")
daff <- diff_data(remote_data, local_data, context = 0)
render_diff(daff)


remote_data %>% left_join(remote_admin_data) %>% distinct(SAILS_EprimeFile)
remote_data %>% left_join(remote_admin_data) %>% count(SAILS_EprimeFile)
