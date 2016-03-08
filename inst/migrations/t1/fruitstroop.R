# Add timepoint1 fruit stroop scores to the database

library("L2TDatabase")
library("dplyr")
library("tidyr")
library("stringr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo)
source("inst/migrations/dates.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Collect dates
df_dates <- collect_dates(paths$score_dates)

# Columns used the 2 sites x 3 timepoints spreadsheets
unique(df_dates$Variable)

# Keep just rows where participants have a test date
df_stroop <- df_dates %>%
  filter(Study == "TimePoint1", str_detect(Variable, "FruitStroop")) %>%
  spread(Variable, Value) %>%
  filter(!is.na(FruitStroop_Date)) %>%
  rename(FS_Score_Dirt = FruitStroop_Score) %>%
  readr::type_convert(.)
df_stroop


# Get T1 scores for both sites. Function sourced via paths$GetSiteInfo
t1 <- GetSiteInfo(separately = TRUE)

# one-off function to select/rename the stroop columns from a spreadsheet
extract_stroop <- . %>%
  select(ParticipantID = Participant_ID, FruitStroop = `fruitstroop_time1-2`)

stroops <- t1 %>%
  lapply(extract_stroop) %>%
  bind_rows

both_scores <- left_join(df_stroop, stroops)

# Check both sources for discrepancies
both_scores %>%
  rename(FS_Score_Info = FruitStroop) %>%
  filter(FS_Score_Info != FS_Score_Dirt) %>%
  mutate(diff = abs(FS_Score_Info - FS_Score_Dirt)) %>%
  arrange(desc(diff)) %>% select(-FruitStroop_Date)






