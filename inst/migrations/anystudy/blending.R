# Add Blending administrations and responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("readr")
source("./inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "./inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "./inst/backup")

# Map from study to study number, from study/short research id to child-study
# id, from child-study id to research id
cds <- l2t_dl$ChildStudy %>% left_join(l2t_dl$Study) %>% left_join(l2t_dl$Child)

# Studies in the database
cds %>% select(Study) %>% distinct


# Get Blending responses

# Specify col types so Participant_ID doesn't get converted to number
data_cols <- cols(
  Study = col_character(),
  Participant_ID = col_character(),
  Date = col_date(format = ""),
  Eprime_Basename = col_character(),
  Running = col_character(),
  Trial = col_double(),
  SupportType = col_character(),
  BlendType = col_character(),
  Stimulus1 = col_character(),
  Stimulus2 = col_character(),
  Stimulus3 = col_character(),
  StimPrompt = col_character(),
  TargetResponse = col_character(),
  ChildResponse = col_character(),
  Correct = col_logical(),
  Administered = col_logical()
)

local_blending_data <- paths$blending %>%
  read_csv(col_types = data_cols) %>%
  rename(
    ShortResearchID = Participant_ID,
    Blending_EprimeFile = Eprime_Basename,
    Blending_Completion = Date) %>%
  mutate(Administered = as.numeric(Administered),
         Correct = as.numeric(Correct))

# Make a table of administrations by getting one row per eprime file
local_blending_admins <- local_blending_data %>%
  select(Study, ShortResearchID, Blending_EprimeFile, Blending_Completion) %>%
  distinct

# Attach birthdates so we can compute age at task completion
dobs <- cds %>%
  select(Study, ChildStudyID, ShortResearchID, Birthdate, FullResearchID)

local_blending_admins <- local_blending_admins %>%
  left_join(dobs, c("Study", "ShortResearchID")) %>%
  mutate(
    Blending_Age = chrono_age(Birthdate, Blending_Completion),
    IDFromFile = str_replace(Blending_EprimeFile, "Blending_", ""))

# Check for children not found in database
local_blending_admins %>% filter(is.na(ChildStudyID))

# Count for repeated filenames
local_blending_admins %>%
  select(Blending_EprimeFile, Blending_Completion) %>%
  count(Blending_EprimeFile) %>%
  filter(n != 1)

# Check for weird cases where id in filename doesn't match the FullResearchID
id_mismatch <- local_blending_admins %>% filter(IDFromFile != FullResearchID)
id_mismatch

# Keep just children in database where ID in filename matches database id
local_blending_admins <- local_blending_admins %>%
  anti_join(id_mismatch, by = "Blending_EprimeFile") %>%
  select(-IDFromFile) %>%
  filter(!is.na(ChildStudyID)) %>%
  arrange(Study, ChildStudyID, Blending_EprimeFile)








# Format administration rows to match database
curr_admins <- l2t_dl$Blending_Admin %>%
  type_convert

local_admins <- match_columns(local_blending_admins, curr_admins)

# Remove adminstrations already in database
rows_to_add <- local_admins %>%
  anti_join(curr_admins, by = c("ChildStudyID", "Blending_EprimeFile")) %>%
  arrange(ChildStudyID, Blending_EprimeFile)
rows_to_add

# Preview who is being added
inner_join(local_blending_admins, type_convert(rows_to_add)) %>%
  select(Study, ShortResearchID, Blending_EprimeFile) %>%
  as.data.frame %>%
  arrange(Study, ShortResearchID)

# There should not be any repeated file names
stopifnot(length(rows_to_add$Blending_EprimeFile) == n_distinct(rows_to_add$Blending_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "Blending_Admin", rows_to_add)
tbl(l2t, "Blending_Admin")




## Find records that need to be updated

# Redownload the table
remote_blending_admins <- collect("Blending_Admin" %from% l2t)

# Attach the database keys to latest data
admins_current_indices <- remote_blending_admins %>%
  select(ChildStudyID, BlendingID)

admins_latest_data <- local_admins %>%
  inner_join(admins_current_indices)  %>%
  arrange(BlendingID) %>%
  mutate(Blending_Completion = format(Blending_Completion))

# Keep just the columns in the latest data
remote_blending_admins <- match_columns(remote_blending_admins, admins_latest_data) %>%
  arrange(BlendingID)

# Preview changes with daff
library("daff")
daff <- diff_data(remote_blending_admins, admins_latest_data, context = 0)
render_diff(daff)

create_diff_table(admins_latest_data, remote_blending_admins, "BlendingID")
overwrite_rows_in_table(l2t, "Blending_Admin", rows = admins_latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "Blending_Admin", rows = admins_latest_data, preview = FALSE)



## Add trial-level data

# Attach local responses to remote administration records using the eprime
# filename and administration date
curr_admins <- collect("Blending_Admin" %from% l2t) %>% type_convert
curr_responses <- l2t_dl$Blending_Responses

curr_admins_with_local_responses <- curr_admins %>%
  inner_join(local_blending_data, by = c("Blending_EprimeFile", "Blending_Completion")) %>%
  match_columns(curr_responses)

# Check for NAs
any(is.na(curr_admins_with_local_responses))
lapply(curr_admins_with_local_responses, unique)

# Which administered trials have missing responses
missing_responses <- curr_admins_with_local_responses %>%
  filter(is.na(Correct), Administered)
missing_responses

# Which administrations contain the missing reponses
curr_admins %>%
  inner_join(missing_responses)

# Remove duplicated rows
response_cols <- c("BlendingID", "Running", "SupportType", "Trial")
responses_to_add <- curr_admins_with_local_responses %>%
  anti_join(curr_responses, by = response_cols) %>%
  anti_join(missing_responses, response_cols) %>%
  arrange(BlendingID, Running, desc(SupportType), Trial)
responses_to_add

append_rows_to_table(l2t, "Blending_Responses", responses_to_add)



## Check for differences between local and remote data

# Redownload the table
remote_admin_data <- collect("Blending_Admin" %from% l2t) %>% type_convert
remote_response_data <- collect("Blending_Responses" %from% l2t)

local_data <- local_blending_data %>%
  select(Blending_EprimeFile, Blending_Completion, Running:Administered) %>%
  anti_join(missing_responses) %>%
  arrange(Blending_EprimeFile, Running, SupportType, Trial)

remote_data <- remote_admin_data %>%
  left_join(remote_response_data) %>%
  select(Blending_EprimeFile, Blending_Completion, Running:Correct) %>%
  arrange(Blending_EprimeFile, Running, SupportType, Trial)

# Preview changes with daff. Will show changes needed to make the remote match
# the local data-set
library("daff")
daff <- diff_data(remote_data, local_data, context = 0)
daff
daff$raw()
render_diff(daff)
