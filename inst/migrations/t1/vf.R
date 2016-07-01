# Add verbal fluency scores to the database

library("L2TDatabase")
library("dplyr")
library("tidyr")
library("stringr")

# Load external dependencies
source("inst/paths.R")
source("inst/migrations/dates.R")
source(paths$GetSiteInfo, chdir = TRUE)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Have verbal fluency norms at hand
df_vf_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("RetrievalFluency") %>%
  collect

# Collect dates/scores from the DIRT spreadsheet
df_dates <- collect_dates(paths$score_dates, recursive = TRUE)

# Keep just verbal fluency data from DIRT
df_vf <- df_dates %>%
  filter(str_detect(Variable, "VerbalFluency")) %>%
  spread(Variable, Value) %>%
  filter(!is.na(VerbalFluency_Score)) %>%
  readr::type_convert(.)

# Check formatting
df_vf %>%
  getElement("VerbalFluency_AgeEquivalent") %>%
  unique %>%
  sort(na.last = TRUE)

df_vf %>%
  filter(str_detect(VerbalFluency_AgeEquivalent, " "))

# Norm check for DIRT data
df_vf %>%
  rename(Raw = VerbalFluency_Score) %>%
  left_join(df_vf_norms) %>%
  filter(VerbalFluency_AgeEquivalent != AgeEq) %>%
  as.data.frame




# Get VF scores from participant info spreadsheets
t1 <- GetSiteInfo(sheet = "ParticipantData_TimePoint1", separately = TRUE)
t2 <- GetSiteInfo(sheet = "TimePoint2", separately = TRUE)
t3 <- GetSiteInfo(sheet = "TimePoint3", separately = TRUE)

# Select/rename just the VF-related columns and identifiers
get_scores_from_info <- function(df) {
  # Select and rename columns we want to compare
  df %>%
    select(ParticipantID = Participant_ID, Study,
           VerbalFluency_Score = starts_with("verbalfluency_raw"),
           VerbalFluency_AgeEquivalent = starts_with("verbalfluency_AE")) %>%
    # Add additional info
    mutate(Source = "ParticipantInfo")
}

# Get the original scores
df_t1_info_wide <- t1 %>% lapply(get_scores_from_info)
df_t2_info_wide <- t2 %>% lapply(get_scores_from_info)
df_t3_info_wide <- t3 %>% lapply(get_scores_from_info)

df_info <- c(df_t1_info_wide, df_t2_info_wide, df_t3_info_wide) %>% bind_rows

# Check formatting
df_info %>%
  getElement("VerbalFluency_AgeEquivalent") %>%
  unique %>%
  sort(na.last = TRUE)

df_info %>%
  filter(str_detect(VerbalFluency_AgeEquivalent, " "))

both_sources <- df_vf %>%
  select(-Site) %>%
  mutate(Source = "DIRT") %>%
  bind_rows(df_info) %>%
  select(-VerbalFluency_Date)

both_wide <- both_sources %>%
  gather(Variable, Value, -Source, -Study, -ParticipantID) %>%
  spread(Source, Value)

# Convert to long format, reshape so cells from both sites can be compared
discrepancies <- both_wide %>%
  filter(DIRT != ParticipantInfo | is.na(DIRT) != is.na(ParticipantInfo))
discrepancies

# Missing values
both_wide %>% filter(is.na(ParticipantInfo))

# Drop discrepant values
obs_to_drop <- discrepancies %>% select(Study, ParticipantID) %>% distinct

shared_scores <- both_sources %>%
  anti_join(obs_to_drop) %>%
  select(-Source) %>%
  distinct %>%
  filter(!is.na(VerbalFluency_Score))

# No double counted scores
shared_scores %>%
  count(Study, ParticipantID) %>%
  filter(n != 1)

# Attach dates to remaining scores
df_dates <- df_vf %>%
  select(Study, ParticipantID, VerbalFluency_Date)

df_with_dates <- shared_scores %>%
  left_join(df_dates, by = c("Study", "ParticipantID")) %>%
  rename(ShortResearchID = ParticipantID)


cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Child")) %>%
  left_join(tbl(l2t, "Study")) %>%
  collect %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate)

# Make sure every verbal fluency corresponds to a database ChildStudy key
anti_join(df_with_dates, cds)

df_can_be_added <- df_with_dates %>%
  left_join(cds) %>%
  rename(VerbalFluency_Completion = VerbalFluency_Date,
         VerbalFluency_Raw = VerbalFluency_Score,
         VerbalFluency_AgeEq = VerbalFluency_AgeEquivalent)

# Calculate age at administration
df_can_be_added <- df_can_be_added %>%
  mutate(VerbalFluency_Age = chrono_age(Birthdate, VerbalFluency_Completion)) %>%
  select(-Study, -ShortResearchID, -Birthdate)

df_can_be_added



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect("VerbalFluency" %from% l2t)

df_can_be_added <- df_can_be_added %>%
  match_columns(current_rows)

new_rows <- df_can_be_added %>%
  anti_join(current_rows, by = c("ChildStudyID")) %>%
  arrange(ChildStudyID)
new_rows

# Add to database
append_rows_to_table(l2t, "VerbalFluency", new_rows)





## Find records that need to be updated

# Redownload the table
remote_data <- collect("VerbalFluency" %from% l2t)

# Attach the database keys to latest local data
current_indices <- remote_data %>%
  select(ChildStudyID, VerbalFluencyID)

latest_data <- df_can_be_added %>%
  inner_join(current_indices) %>%
  arrange(VerbalFluencyID)

# Keep just the columns in the latest data (i.e., drop database-oriented
# VerbalFluency_Timestamp)
remote_data <- match_columns(remote_data, latest_data) %>%
  filter(ChildStudyID %in% latest_data$ChildStudyID)

# Make date into YYYY-MM-DD string
latest_data$VerbalFluency_Completion <- latest_data$VerbalFluency_Completion %>% format
latest_data

# Preview changes with daff
library("daff")
daff <- diff_data(remote_data, latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "VerbalFluencyID")

overwrite_rows_in_table(l2t, "VerbalFluency", rows = latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "VerbalFluency", rows = latest_data, preview = FALSE)

# Check one last time
remote_data <- collect("VerbalFluency" %from% l2t)
anti_join(remote_data, latest_data, by = "VerbalFluencyID")
anti_join(remote_data, latest_data)
anti_join(latest_data, remote_data)
