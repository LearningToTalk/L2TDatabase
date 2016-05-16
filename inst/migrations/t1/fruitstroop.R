# Add Fruit Stroop scores to the database

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
df_dates <- collect_dates(paths$score_dates, recursive = TRUE)

# Columns used the 2 sites x 3 timepoints spreadsheets
df_dates$Variable %>% unique %>% sort

# Get scores from DIRT
df_stroop <- df_dates %>%
  filter(str_detect(Variable, "FruitStroop")) %>%
  spread(Variable, Value) %>%
  mutate(Source = "DIRT") %>%
  readr::type_convert(.)
df_stroop




# Get T1/T2 scores for both sites
t1 <- GetSiteInfo(separately = TRUE)
t2 <- GetSiteInfo(separately = TRUE, sheet = "TimePoint2")

# one-off function to select/rename the stroop columns from a spreadsheet
extract_stroop <- . %>%
  select(Site, Study, ParticipantID = Participant_ID,
         FruitStroop_Score = starts_with("fruitstroop_time")) %>%
  mutate(Source = "ParticipantInfo")

t1_stroops <- t1 %>% lapply(extract_stroop) %>% bind_rows
t2_stroops <- t2 %>% lapply(extract_stroop) %>% bind_rows

stroops <- bind_rows(t1_stroops, t2_stroops)

stroops
df_stroop

# Compare DIRT versus participant info
both_scores <- bind_rows(df_stroop, stroops)

discrepancies <- both_scores %>%
  select(-FruitStroop_Date) %>%
  spread(Source, FruitStroop_Score) %>%
  filter(DIRT != ParticipantInfo)

both_scores %>%
  mutate(Full = FruitStroop_Score * 9)

df_stroop %>%
  count(Study)

# Check for non-standard roundings
scores <- as.data.frame(data_frame(
  Points = 0:27,
  Round1 = round(Points / 9, 1),
  Round1_Reconst = round(Points / 9, 1) * 9,
  Round2 = round(Points / 9, 2),
  Round2_Reconst = round(Points / 9, 2) * 9
))

both_scores %>%
  filter(!(FruitStroop_Score %in% scores$Round2)) %>%
  as.data.frame %>%
  filter(!is.na(FruitStroop_Score))

# Keep just the dates
fs_dates <- df_stroop %>%
  anti_join(discrepancies, by = c("Study", "ParticipantID")) %>%
  select(Study, ParticipantID, FruitStroop_Date)

# Combine dates to participant info scores
scores_with_dates <- stroops %>%
  anti_join(discrepancies, by = c("Study", "ParticipantID")) %>%
  filter(!is.na(FruitStroop_Score)) %>%
  left_join(fs_dates)

# Scores from participant info that were not in DIRT (because they have no date)
scores_with_dates %>%
  filter(is.na(FruitStroop_Date))

# Keep just kids with dates. Reconstruct round score
scores_to_add <- scores_with_dates %>%
  filter(!is.na(FruitStroop_Date)) %>%
  mutate(FruitStroop_Raw = round(FruitStroop_Score * 9, 0)) %>%
  rename(FruitStroop_Completion = FruitStroop_Date)

# Confirm reconstruction
all(round(scores_to_add$FruitStroop_Raw / 9, 2) == scores_to_add$FruitStroop_Score)

scores_to_add %>% semi_join(discrepancies)




# Get child-level info and keys
cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Child")) %>%
  left_join(tbl(l2t, "Study")) %>%
  collect %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate)

# Make sure every Fruit Stroop corresponds to a database ChildStudy key
anti_join(scores_to_add, cds)

# Attach child-level info to scores
df_can_be_added <- scores_to_add %>%
  rename(ShortResearchID = ParticipantID) %>%
  left_join(cds)


df_can_be_added <- df_can_be_added %>%
  mutate(FruitStroop_Age = chrono_age(Birthdate, FruitStroop_Completion)) %>%
  select(-Study, -ShortResearchID, -Birthdate)

df_can_be_added



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect("FruitStroop" %from% l2t)

df_can_be_added <- df_can_be_added %>%
  match_columns(current_rows)

new_rows <- df_can_be_added %>%
  anti_join(current_rows, by = c("ChildStudyID")) %>%
  arrange(ChildStudyID)


# Add to database
append_rows_to_table(l2t, "FruitStroop", new_rows)





## Find records that need to be updated

# Redownload the table
remote_data <- collect("FruitStroop" %from% l2t)

# Attach the database keys to latest data
current_indices <- remote_data %>%
  select(ChildStudyID, FruitStroopID)

latest_data <- df_can_be_added %>%
  inner_join(current_indices)

# Keep just the columns in the latest data
remote_data <- match_columns(remote_data, latest_data) %>%
  filter(ChildStudyID %in% latest_data$ChildStudyID)

latest_data$FruitStroop_Completion <- latest_data$FruitStroop_Completion %>% format
latest_data

# Preview changes with daff
library("daff")
daff <- diff_data(remote_data, latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "FruitStroopID")

overwrite_rows_in_table(l2t, "FruitStroop", rows = latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "FruitStroop", rows = latest_data, preview = FALSE)

# Check one last time
remote_data <- collect("FruitStroop" %from% l2t)
anti_join(remote_data, latest_data, by = "FruitStroopID")
anti_join(remote_data, latest_data)
anti_join(latest_data, remote_data)
