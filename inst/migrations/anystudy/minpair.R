# Add Minimal Pairs administrations and responses to the database
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
cds <- left_join(l2t_dl$ChildStudy, l2t_dl$Study) %>%
  left_join(l2t_dl$Child)

# Studies in the database
cds %>% select(Study) %>% distinct

# Get minpair responses
mp <- read_csv(paths$minpairs) %>%
  mutate(ShortResearchID = str_extract(Eprime_Basename, "(?<=MINP_)\\d{3}\\w")) %>%
  rename(MinPair_Dialect = Dialect,
         MinPair_EprimeFile = Eprime_Basename,
         MinPair_Completion = Date)

# Make a table of administrations by getting one row per eprimefile
mp_admins <- mp %>%
  select(Study, ShortResearchID, MinPair_Dialect,
         MinPair_EprimeFile, MinPair_Completion) %>%
  distinct


mp_admins %>% select(Study) %>% distinct
mp_admins %>% select(MinPair_EprimeFile) %>% distinct

# Repeated filenames
mp_admins %>%
  select(MinPair_Dialect, MinPair_EprimeFile, MinPair_Completion) %>%
  count(MinPair_EprimeFile) %>%
  filter(n != 1)

# Get adminstrations for children in database
with_ids <- mp_admins %>%
  inner_join(cds, by = c("Study", "ShortResearchID")) %>%
  select(Study, ShortResearchID, ChildStudyID, MinPair_Dialect, MinPair_EprimeFile,
         FullResearchID, MinPair_Completion, Birthdate) %>%
  mutate(
    MinPair_Age = chrono_age(Birthdate, MinPair_Completion),
    IDFromFile = str_replace(MinPair_EprimeFile, "MINP_", ""))

# Check for weird cases where id in filename doesn't match the FullResearchID
id_mismatch <- with_ids %>% filter(IDFromFile != FullResearchID)
id_mismatch
with_ids <- anti_join(with_ids, id_mismatch)

# Format administration rows to match database
curr_admins <- l2t_dl$MinPair_Admin %>% type_convert
local_admins <- match_columns(with_ids, curr_admins)

# Remove adminstrations already in database
rows_to_add <- local_admins %>%
  anti_join(curr_admins, by = c("ChildStudyID", "MinPair_Dialect", "MinPair_EprimeFile")) %>%
  arrange(ChildStudyID, MinPair_Completion)
rows_to_add

# Preview who is being added
inner_join(with_ids, rows_to_add) %>%
  select(Study, ShortResearchID) %>%
  as.data.frame %>%
  arrange(Study, ShortResearchID)

# There should not be any repeated file names
stopifnot(length(rows_to_add$MinPair_EprimeFile) == n_distinct(rows_to_add$MinPair_EprimeFile))
stopifnot(length(with_ids$MinPair_EprimeFile) == n_distinct(with_ids$MinPair_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "MinPair_Admin", rows_to_add)
tbl(l2t, "MinPair_Admin")


## Find records that need to be updated

# Redownload the table
admins_remote_data <- collect("MinPair_Admin" %from% l2t)

# Attach the database keys to latest data
admins_current_indices <- admins_remote_data %>%
  select(ChildStudyID, MinPairID)

admins_latest_data <- local_admins %>%
  inner_join(admins_current_indices)  %>%
  arrange(MinPairID) %>%
  mutate(MinPair_Completion = format(MinPair_Completion))

# Keep just the columns in the latest data
admins_remote_data <- match_columns(admins_remote_data, admins_latest_data) %>%
  # filter(ChildStudyID %in% admins_latest_data$ChildStudyID) %>%
  arrange(MinPairID) %>%
  mutate(MinPair_Completion = format(MinPair_Completion))

# Preview changes with daff
library("daff")
daff <- diff_data(admins_remote_data, admins_latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(admins_latest_data, admins_remote_data, "MinPairID")

overwrite_rows_in_table(l2t, "MinPair_Admin", rows = admins_latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "MinPair_Admin", rows = admins_latest_data, preview = FALSE)




# # One-off to add ages to the database
# with_updated_ages <- admins_remote_data %>%
#   left_join(cds) %>%
#   mutate(MinPair_Age = chrono_age(Birthdate, MinPair_Completion)) %>%
#   match_columns(admins_remote_data)
#
# # Preview changes with daff
# library("daff")
# daff <- diff_data(admins_remote_data, with_updated_ages, context = 0)
# render_diff(daff)
#
# create_diff_table(with_updated_ages, admins_remote_data, "MinPairID")
# overwrite_rows_in_table(l2t, "MinPair_Admin", rows = with_updated_ages, preview = TRUE)
# overwrite_rows_in_table(l2t, "MinPair_Admin", rows = with_updated_ages, preview = FALSE)
#



## Add trial-level data

# Attach local responses to remote administration records using the eprime
# filename, administration date and dialect
curr_admins <- collect("MinPair_Admin" %from% l2t) %>% type_convert
curr_responses <- l2t_dl$MinPair_Responses

with_responses <- curr_admins %>%
  inner_join(mp, by = c("MinPair_Dialect", "MinPair_EprimeFile", "MinPair_Completion")) %>%
  match_columns(curr_responses) %>%
  mutate(Correct = as.numeric(Correct))

# Check for NAs
any(is.na(with_responses))
lapply(with_responses, unique)

# Which responses are missing
missing_responses <- with_responses %>% filter(is.na(Correct))
missing_responses

# Which administrations contain the missing reponses
curr_admins %>%
  inner_join(missing_responses)

# Remove duplicated rows
responses_to_add <- with_responses %>%
  anti_join(curr_responses, by = c("MinPairID", "Running", "Item1", "Item2", "Trial")) %>%
  anti_join(missing_responses, by = c("MinPairID", "Running", "Item1", "Item2", "Trial")) %>%
  arrange(MinPairID, Running, Trial)
responses_to_add

append_rows_to_table(l2t, "MinPair_Responses", responses_to_add)



## Check for responses that need to be updated

# Redownload the table
resp_remote_data <- collect("MinPair_Responses" %from% l2t)

indices <- describe_tbl(l2t, "MinPair_Responses") %>%
  filter(Index != "") %>%
  getElement("Field")

# Attach the database keys to latest data

resp_current_indices <- resp_remote_data %>%
  left_join(curr_admins) %>%
  select(one_of(indices), Running, Trial)

resp_latest_data <- with_responses %>%
  inner_join(resp_current_indices) %>%
  arrange(MinPairID, ResponseID)

# Keep just the columns in the latest data
resp_remote_data <- match_columns(resp_remote_data, resp_latest_data) %>%
  arrange(MinPairID, ResponseID)


# Preview changes with daff
library("daff")
daff <- diff_data(resp_remote_data, resp_latest_data, context = 0)
render_diff(daff)

# Only subtractions for administrations that have been archived
