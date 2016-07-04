# Add SAILS administrations and responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("readr")
source("inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Map from study to study number, from study/short research id to child-study
# id, from child-study id to research id
cds <- l2t_dl$ChildStudy %>% left_join(l2t_dl$Study) %>% left_join(l2t_dl$Child)

# Studies in the database
cds %>% select(Study) %>% distinct




# Get SAILS responses
local_sails_data <- paths$sails %>%
  # need to specify col types so Participant_ID doesn't get converted to number
  read_csv(col_types = "ccccDciicccciiidc") %>%
  rename(
    ShortResearchID = Participant_ID,
    SAILS_Dialect = Dialect,
    SAILS_EprimeFile = Eprime_Basename,
    SAILS_Completion = Date)

# Make a table of administrations by getting one row per eprime file
local_sails_admins <- local_sails_data %>%
  select(Study, ShortResearchID, SAILS_Dialect,
         SAILS_EprimeFile, SAILS_Completion) %>%
  distinct

# Attach birthdates so we can compute age at task completion
dobs <- cds %>%
  select(Study, ChildStudyID, ShortResearchID, Birthdate, FullResearchID)

local_sails_admins <- local_sails_admins %>%
  left_join(dobs, c("Study", "ShortResearchID")) %>%
  mutate(
    SAILS_Age = chrono_age(Birthdate, SAILS_Completion),
    IDFromFile = str_replace(SAILS_EprimeFile, "SAILS_", ""))

# Check for children not found in database
local_sails_admins %>% filter(is.na(ChildStudyID))

# Count for repeated filenames
local_sails_admins %>%
  select(SAILS_Dialect, SAILS_EprimeFile, SAILS_Completion) %>%
  count(SAILS_EprimeFile) %>%
  filter(n != 1)

# Check for weird cases where id in filename doesn't match the FullResearchID
id_mismatch <- local_sails_admins %>% filter(IDFromFile != FullResearchID)
id_mismatch

# Keep just children in database where ID in filename matches database id
local_sails_admins <- local_sails_admins %>%
  anti_join(id_mismatch, by = "SAILS_EprimeFile") %>%
  select(-IDFromFile) %>%
  filter(!is.na(ChildStudyID)) %>%
  arrange(Study, ChildStudyID, SAILS_EprimeFile)








# Format administration rows to match database
curr_admins <- l2t_dl$SAILS_Admin %>%
  type_convert

local_admins <- match_columns(local_sails_admins, curr_admins)

# Remove adminstrations already in database
rows_to_add <- local_admins %>%
  anti_join(curr_admins, by = c("ChildStudyID", "SAILS_Dialect", "SAILS_EprimeFile")) %>%
  arrange(ChildStudyID, SAILS_EprimeFile)
rows_to_add

# Preview who is being added
inner_join(local_sails_admins, type_convert(rows_to_add)) %>%
  select(Study, ShortResearchID, SAILS_EprimeFile) %>%
  as.data.frame %>%
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

admins_latest_data <- local_admins %>%
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
curr_admins <- collect("SAILS_Admin" %from% l2t) %>% type_convert
curr_responses <- l2t_dl$SAILS_Responses

curr_admins_with_local_responses <- curr_admins %>%
  inner_join(local_sails_data, by = c("SAILS_Dialect", "SAILS_EprimeFile", "SAILS_Completion")) %>%
  match_columns(curr_responses)

# Check for NAs
any(is.na(curr_admins_with_local_responses))
lapply(curr_admins_with_local_responses, unique)

# Which responses are missing
missing_responses <- curr_admins_with_local_responses %>%
  filter(is.na(Correct))
missing_responses

# Which administrations contain the missing reponses
curr_admins %>%
  inner_join(missing_responses)

# Remove duplicated rows
response_cols <- c("SAILSID", "Running", "Cycle", "Trial")
responses_to_add <- curr_admins_with_local_responses %>%
  anti_join(curr_responses, by = response_cols) %>%
  anti_join(missing_responses, response_cols) %>%
  arrange_(.dots = response_cols)
responses_to_add

append_rows_to_table(l2t, "SAILS_Responses", responses_to_add)



## Check for differences between local and remote data

# Redownload the table
remote_admin_data <- collect("SAILS_Admin" %from% l2t) %>% type_convert
remote_response_data <- collect("SAILS_Responses" %from% l2t)

local_data <- local_sails_data %>%
  select(SAILS_EprimeFile, SAILS_Completion, SAILS_Dialect, Running:Correct) %>%
  arrange(SAILS_EprimeFile, Running, Trial)

remote_data <- remote_admin_data %>%
  left_join(remote_response_data) %>%
  select(SAILS_EprimeFile, SAILS_Completion, SAILS_Dialect, Running:Correct) %>%
  arrange(SAILS_EprimeFile, Running, Trial)

# Preview changes with daff. Will show changes needed to make the remote match
# the local data-set
library("daff")
daff <- diff_data(remote_data, local_data, context = 0)
render_diff(daff)
