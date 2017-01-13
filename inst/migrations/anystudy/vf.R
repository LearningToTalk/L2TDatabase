# Add verbal fluency scores to the database
library("L2TDatabase")
library("dplyr")
library("tidyr")
library("stringr")
library("readr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo, chdir = TRUE)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get info for both sites. Function sourced via paths$GetSiteInfo
t1 <- get_study_info("TimePoint1")
t2 <- get_study_info("TimePoint2")
t3 <- get_study_info("TimePoint3")
ci1 <- get_study_info("CochlearV1")
ci2 <- get_study_info("CochlearV2")
cim <- get_study_info("CochlearMatching")
lt <- get_study_info("LateTalker")
medu <- get_study_info("MaternalEd")
dialect <- get_study_info("DialectSwitch")


# Select the VerbalFluency columns if they exist, otherwise return a blank
# dataframe
process_vf_scores <- function(df) {
  if (nrow(df) == 0) {
    return(data_frame())
  }

  # Rules for converting the columns
  cols_types <- cols(
    Study = col_character(),
    ShortResearchID = col_character(),
    VerbalFluency_AgeEquivalent = col_character())

  format_if_exists <- function(...) format(..., na.encode = FALSE)

  df_data <- df %>%
    select(Study,
           ShortResearchID = Participant_ID,
           VerbalFluency_Completion = maybe_matches("VerbalFluency_Date"),
           VerbalFluency_Score = maybe_matches("verbalfluency_raw|VerbalFluency_Score"),
           VerbalFluency_AgeEquivalent = maybe_matches("verbalfluency_AE|VerbalFluency_AgeEquivalent")) %>%
    type_convert(cols_types) %>%
    # Convert the date to a string
    mutate_at(vars(ends_with("Completion")), format_if_exists)

  # FruitStroop not administered in every study, so return an empty dataframe if
  # no data found
  no_data <- identical(names(df_data), c("Study", "ShortResearchID"))
  if (no_data) {
    df_data <- data_frame()
  }

  df_data
}

df_scores <- c(t1, t2, t3, ci1, ci2, cim, lt, medu, dialect) %>%
  lapply(process_vf_scores) %>%
  bind_rows()

df_scores

# Have verbal fluency norms at hand
df_vf_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("RetrievalFluency") %>%
  collect()

# Check formatting
df_scores %>%
  getElement("VerbalFluency_AgeEquivalent") %>%
  unique() %>%
  sort(na.last = TRUE)

df_scores %>%
  filter(str_detect(VerbalFluency_AgeEquivalent, " "))

# Norm check
df_scores %>%
  rename(Raw = VerbalFluency_Score) %>%
  left_join(df_vf_norms) %>%
  filter(VerbalFluency_AgeEquivalent != AgeEq) %>%
  print(n = Inf)

df_scores_to_add <- df_scores %>%
  filter(!is.na(VerbalFluency_Completion))

# No double counted scores
df_scores_to_add %>%
  count(Study, ShortResearchID) %>%
  filter(n != 1)

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

# Make sure every verbal fluency corresponds to a database ChildStudy key
anti_join(df_scores_to_add, df_cds) %>%
  print(n = Inf)

df_can_be_added <- df_scores_to_add %>%
  inner_join(df_cds) %>%
  rename(VerbalFluency_Raw = VerbalFluency_Score,
         VerbalFluency_AgeEq = VerbalFluency_AgeEquivalent)

# Calculate age at administration
df_can_be_added <- df_can_be_added %>%
  mutate(VerbalFluency_Age = chrono_age(Birthdate, VerbalFluency_Completion)) %>%
  select(-Study, -ShortResearchID, -Birthdate)
df_can_be_added



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
df_current_rows <- collect("VerbalFluency" %from% l2t)

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = df_current_rows,
  required_cols = "ChildStudyID")

df_to_add %>% print(n = Inf)

# Add to database
append_rows_to_table(l2t, "VerbalFluency", df_to_add)





## Find records that need to be updated

# Redownload the table
df_remote <- collect("VerbalFluency" %from% l2t)

# Attach the database keys to latest local data
df_remote_indices <- df_remote %>%
  select(ChildStudyID, VerbalFluencyID)

df_local <- df_can_be_added %>%
  inner_join(df_remote_indices) %>%
  arrange(VerbalFluencyID)

# Keep just the columns in the latest data (i.e., drop database-oriented
# VerbalFluency_Timestamp)
df_remote <- match_columns(df_remote, df_local) %>%
  filter(ChildStudyID %in% df_local$ChildStudyID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote, df_local, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote, "VerbalFluencyID")

overwrite_rows_in_table(l2t, "VerbalFluency", rows = df_local, preview = TRUE)
overwrite_rows_in_table(l2t, "VerbalFluency", rows = df_local, preview = FALSE)

# Check one last time
df_remote <- collect("VerbalFluency" %from% l2t)
anti_join(df_remote, df_local, by = "VerbalFluencyID")
anti_join(df_remote, df_local)
anti_join(df_local, df_remote)
anti_join(df_can_be_added, df_remote)
anti_join(df_remote, df_can_be_added)

