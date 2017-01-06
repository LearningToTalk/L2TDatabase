# Add Fruit Stroop scores to the database

library("L2TDatabase")
library("dplyr")
library("tidyr")
library("readr")
library("stringr")

# Load external dependencies
source("inst/paths.R")
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

# Select the Fruit Stroop columns if they exist, otherwise return a blank
# dataframe
process_fs_scores <- function(df) {
  # Rules for converting the columns
  cols_types <- cols(
    Study = col_character(),
    ShortResearchID = col_character())

  format_if_exists <- function(...) format(..., na.encode = FALSE)

  df_data <- df %>%
    select(Study,
           ShortResearchID = Participant_ID,
           FruitStroop_Date = maybe_starts_with("FruitStroop_Date"),
           FruitStroop_Score = maybe_starts_with("fruitstroop_time")) %>%
    type_convert(cols_types) %>%
    # Convert the date to a string
    mutate_at(vars(ends_with("Date")), format_if_exists)

  # FruitStroop not administered in every study, so return an empty dataframe if
  # no data found
  no_data <- identical(names(df_data), c("Study", "ShortResearchID"))
  if (no_data) {
    df_data <- data_frame()
  }

  df_data
}

df_scores <- c(t1, t2, t3, ci1, ci2, cim, lt, medu) %>%
  lapply(process_fs_scores) %>%
  bind_rows()

# Some possible roundings of Fruit Stroop scores
possible_fs_scores <- as.data.frame(data_frame(
  Points = 0:27,
  Round1 = round(Points / 9, 1),
  Round1_Reconst = round(Points / 9, 1) * 9,
  Round2 = round(Points / 9, 2),
  Round2_Reconst = round(Points / 9, 2) * 9
))

# Check for data that doesn't match the standard 2-digit rounding
df_scores %>%
  filter(!(FruitStroop_Score %in% scores$Round2)) %>%
  as.data.frame() %>%
  filter(!is.na(FruitStroop_Score))

# Keep just kids with dates. Reconstruct original raw score
df_scores_to_add <- df_scores %>%
  filter(!is.na(FruitStroop_Date)) %>%
  mutate(FruitStroop_Raw = round(FruitStroop_Score * 9, 0)) %>%
  rename(FruitStroop_Completion = FruitStroop_Date)

# Confirm reconstruction
all(round(df_scores_to_add$FruitStroop_Raw / 9, 2) == df_scores_to_add$FruitStroop_Score)




# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

# Make sure every Fruit Stroop corresponds to a database ChildStudy key
anti_join(df_scores_to_add, df_cds)

# Attach child-level info to scores
df_can_be_added <- df_scores_to_add %>%
  left_join(df_cds)

df_can_be_added <- df_can_be_added %>%
  mutate(FruitStroop_Age = chrono_age(Birthdate, FruitStroop_Completion)) %>%
  select(-Study, -ShortResearchID, -Birthdate)
df_can_be_added

## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
df_current_rows <- collect("FruitStroop" %from% l2t)

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = df_current_rows,
  required_cols = "ChildStudyID")

df_to_add %>% print(n = Inf)

# Check for multiple administrations
df_to_add %>% count(ChildStudyID) %>% filter(n != 1)

# Add to database
append_rows_to_table(l2t, "FruitStroop", df_to_add)





## Find records that need to be updated

# Redownload the table
df_remote <- collect("FruitStroop" %from% l2t)

# Attach the database keys to latest data
df_remote_indices <- df_remote %>%
  select(ChildStudyID, FruitStroopID)

df_local <- df_can_be_added %>%
  inner_join(df_remote_indices) %>%
  arrange(FruitStroopID)

# Keep just the columns in the latest data
df_remote <- match_columns(df_remote, df_local) %>%
  filter(ChildStudyID %in% df_local$ChildStudyID) %>%
  arrange(FruitStroopID)

df_local$FruitStroop_Completion <- df_local$FruitStroop_Completion %>%
  format(na.encode = FALSE)
df_local

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote, df_local, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote, "FruitStroopID")

overwrite_rows_in_table(l2t, "FruitStroop", rows = df_local, preview = TRUE)
overwrite_rows_in_table(l2t, "FruitStroop", rows = df_local, preview = FALSE)

# Check one last time
df_remote <- collect("FruitStroop" %from% l2t)
anti_join(df_remote, df_local, by = "FruitStroopID")
anti_join(df_remote, df_local)
anti_join(df_local, df_remote)
anti_join(df_can_be_added, df_remote)
anti_join(df_remote, df_can_be_added)
