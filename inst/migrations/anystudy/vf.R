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

# Get info for both sites. Function sourced via paths$GetSiteInfo
t1 <- get_study_info("TimePoint1")
t2 <- get_study_info("TimePoint2")
t3 <- get_study_info("TimePoint3")
ci1 <- get_study_info("CochlearV1")
ci2 <- get_study_info("CochlearV2")
cim <- get_study_info("CochlearMatching")
lt <- get_study_info("LateTalker")
medu <- get_study_info("Medu") %>%
  lapply(. %>% mutate(Study = "MaternalEd"))

process_scores <- . %>%
  select(Study,
         ShortResearchID = Participant_ID,
         VerbalFluency_Completion = maybe_matches("VerbalFluency_Date"),
         VerbalFluency_Score = maybe_starts_with("verbalfluency_raw"),
         VerbalFluency_AgeEquivalent = maybe_starts_with("verbalfluency_AE")) %>%
  readr::type_convert() %>%
  mutate(VerbalFluency_Completion = format(VerbalFluency_Completion))

df_scores <- c(t1, t2, t3, ci1, ci2, cim, lt, medu) %>%
  lapply(process_scores) %>%
  bind_rows()

# Have verbal fluency norms at hand
df_vf_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("RetrievalFluency") %>%
  collect()

# # Collect dates/scores from the DIRT spreadsheet
# df_dates <- collect_dates(paths$score_dates, recursive = TRUE)
#
# # Keep just verbal fluency data from DIRT
# df_vf <- df_dates %>%
#   filter(Study %in% c("TimePoint1", "TimePoint2", "TimePoint3")) %>%
#   filter(str_detect(Variable, "VerbalFluency")) %>%
#   spread(Variable, Value) %>%
#   filter(!is.na(VerbalFluency_Score)) %>%
#   readr::type_convert(.)

# Check formatting
df_scores %>%
  getElement("VerbalFluency_AgeEquivalent") %>%
  unique() %>%
  sort(na.last = TRUE)

df_scores %>%
  filter(str_detect(VerbalFluency_AgeEquivalent, " "))

# Norm check for DIRT data
df_scores %>%
  rename(Raw = VerbalFluency_Score) %>%
  left_join(df_vf_norms) %>%
  filter(VerbalFluency_AgeEquivalent != AgeEq) %>%
  print(n = Inf)

df_vf_scores <- df_scores %>%
  filter(!is.na(VerbalFluency_Completion))

# No double counted scores
df_vf_scores %>%
  count(Study, ShortResearchID) %>%
  filter(n != 1)

cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Child")) %>%
  left_join(tbl(l2t, "Study")) %>%
  collect() %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate)

# Make sure every verbal fluency corresponds to a database ChildStudy key
anti_join(df_vf_scores, cds) %>%
  print(n = Inf)

df_can_be_added <- df_vf_scores %>%
  inner_join(cds) %>%
  rename(VerbalFluency_Raw = VerbalFluency_Score,
         VerbalFluency_AgeEq = VerbalFluency_AgeEquivalent)

# Calculate age at administration
df_can_be_added <- df_can_be_added %>%
  mutate(VerbalFluency_Age = chrono_age(Birthdate, VerbalFluency_Completion)) %>%
  select(-Study, -ShortResearchID, -Birthdate)

df_can_be_added



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect("VerbalFluency" %from% l2t)

# Find completely new records that need to be added
to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = current_rows,
  required_cols = "ChildStudyID")

to_add %>% print(n = Inf)

# Add to database
append_rows_to_table(l2t, "VerbalFluency", to_add)





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
