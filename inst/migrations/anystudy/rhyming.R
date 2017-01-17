# Add Rhyming administrations and responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("readr")
source("./inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "./inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "./inst/backup")

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, FullResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()



## Load Rhyming responses

# Specify col types so Participant_ID doesn't get converted to number
data_cols <- cols(
  Study = col_character(),
  Participant_ID = col_character(),
  Date = col_date(format = ""),
  Eprime_Basename = col_character(),
  Running = col_character(),
  Trial = col_double(),
  Stimulus1 = col_character(),
  Stimulus2 = col_character(),
  Stimulus3 = col_character(),
  Stimulus4 = col_character(),
  RhymeGroup = col_character(),
  TargetResponse = col_character(),
  ChildResponse = col_character(),
  Correct = col_logical()
)

df_local_rhyming <- paths$rhyming %>%
  read_csv(col_types = data_cols) %>%
  rename(
    ShortResearchID = Participant_ID,
    Rhyming_EprimeFile = Eprime_Basename,
    Rhyming_Completion = Date) %>%
  mutate(Correct = as.numeric(Correct))

# Make sure the CochlearMatching kids have the correct Study name
cimatching_ids <- df_cds %>%
  filter(Study == "CochlearMatching") %>%
  getElement("ShortResearchID")

df_local_rhyming <- df_local_rhyming %>%
  mutate(Study = ifelse(ShortResearchID %in% cimatching_ids, "CochlearMatching", Study))

df_local_rhyming %>% count(Study)

# Make a table of administrations by getting one row per eprime file
df_local_rhyming_admin <- df_local_rhyming %>%
  select(Study, ShortResearchID, Rhyming_EprimeFile, Rhyming_Completion) %>%
  distinct()

# Attach birthdates so we can compute age at task completion
# dobs <- df_cds %>%
  # select(Study, ChildStudyID, ShortResearchID, Birthdate, FullResearchID)

df_local_rhyming_admin <- df_local_rhyming_admin %>%
  left_join(df_cds, c("Study", "ShortResearchID")) %>%
  mutate(
    Rhyming_Age = chrono_age(Birthdate, Rhyming_Completion),
    IDFromFile = str_replace(Rhyming_EprimeFile, "Rhyming_", ""))

# Check for children not found in database
df_local_rhyming_admin %>% filter(is.na(ChildStudyID))

# Count for repeated filenames
df_local_rhyming_admin %>%
  select(Rhyming_EprimeFile, Rhyming_Completion) %>%
  count(Rhyming_EprimeFile) %>%
  filter(n != 1)

# Check for weird cases where id in filename doesn't match the FullResearchID
df_id_mismatch <- df_local_rhyming_admin %>%
  filter(IDFromFile != FullResearchID)
df_id_mismatch

# Keep just children in database where ID in filename matches database id
df_local_rhyming_admin <- df_local_rhyming_admin %>%
  anti_join(df_id_mismatch, by = "Rhyming_EprimeFile") %>%
  select(-IDFromFile) %>%
  filter(!is.na(ChildStudyID)) %>%
  arrange(Study, ChildStudyID, Rhyming_EprimeFile)

# Format administration rows to match database
df_remote_rhyming_admin <- tbl(l2t, "Rhyming_Admin") %>%
  collect() %>%
  type_convert()

# Remove adminstrations already in database
df_to_add <- find_new_rows_in_table(
  data = df_local_rhyming_admin,
  ref_data = df_remote_rhyming_admin,
  required_cols = "ChildStudyID")
df_to_add


# Preview who is being added
df_local_rhyming_admin %>%
  inner_join(type_convert(df_to_add)) %>%
  select(Study, ShortResearchID, Rhyming_EprimeFile) %>%
  arrange(Study, ShortResearchID) %>%
  print(n = Inf)

# There should not be any repeated file names
stopifnot(length(df_to_add$Rhyming_EprimeFile) == n_distinct(df_to_add$Rhyming_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "Rhyming_Admin", df_to_add)





## Find records that need to be updated

# Redownload the table
df_remote_rhyming_admin <- collect("Rhyming_Admin" %from% l2t)

# Attach the database keys to latest data
df_admins_current_indices <- df_remote_rhyming_admin %>%
  select(ChildStudyID, RhymingID)

df_admins_latest_data <- df_local_rhyming_admin %>%
  inner_join(df_admins_current_indices)  %>%
  arrange(RhymingID) %>%
  mutate(Rhyming_Completion = format(Rhyming_Completion)) %>%
  match_columns(df_remote_rhyming_admin)

# Keep just the columns in the latest data
df_remote_rhyming_admin <- df_remote_rhyming_admin %>%
  match_columns(df_admins_latest_data) %>%
  arrange(RhymingID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote_rhyming_admin, df_admins_latest_data, context = 0)
render_diff(daff)

create_diff_table(df_admins_latest_data, df_remote_rhyming_admin, "RhymingID")
overwrite_rows_in_table(l2t, "Rhyming_Admin", rows = df_admins_latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "Rhyming_Admin", rows = df_admins_latest_data, preview = FALSE)



## Add trial-level data

# Attach local responses to remote administration records using the eprime
# filename and administration date
df_remote_admins <- tbl(l2t, "Rhyming_Admin") %>%
  collect() %>%
  type_convert()

df_remote_responses <- tbl(l2t, "Rhyming_Responses") %>%
  collect() %>%
  type_convert()

df_local_response_with_admin_ids <- df_local_rhyming %>%
  inner_join(df_remote_admins) %>%
  match_columns(df_remote_responses)

# Check for NAs
any(is.na(df_local_response_with_admin_ids))
lapply(df_local_response_with_admin_ids, unique)


# Remove duplicated rows

# Remove adminstrations already in database
df_to_add <- find_new_rows_in_table(
  data = df_local_response_with_admin_ids,
  ref_data = df_remote_responses,
  required_cols = "RhymingID")
df_to_add

append_rows_to_table(l2t, "Rhyming_Responses", df_to_add)



## Check for differences between local and remote data

# Redownload the table
df_remote_admin <- tbl(l2t, "Rhyming_Admin") %>%
  collect() %>%
  type_convert()

df_remote_responses <- tbl(l2t, "Rhyming_Responses") %>%
  collect() %>%
  type_convert()

df_local_data <- df_local_rhyming %>%
  select(Rhyming_EprimeFile, Rhyming_Completion, Running:Correct) %>%
  arrange(Rhyming_EprimeFile, Running, Trial)

df_remote_data <- df_remote_admin %>%
  left_join(df_remote_responses) %>%
  select(Rhyming_EprimeFile, Rhyming_Completion, Running:Correct) %>%
  arrange(Rhyming_EprimeFile, Running, Trial)

# Preview changes with daff. Will show changes needed to make the remote match
# the local data-set
library("daff")
daff <- diff_data(df_remote_data, df_local_data, context = 0)
render_diff(daff)

