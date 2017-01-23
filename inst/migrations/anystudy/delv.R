# Add DELV scores to the database
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

# Select the DELV columns if they exist, otherwise return a blank
# dataframe
process_delv_scores <- function(df) {
  if (nrow(df) == 0) {
    return(data_frame())
  }

  # Rules for converting the columns
  cols_types <- cols(
    Study = col_character(),
    ShortResearchID = col_character())

  format_if_exists <- function(...) format(..., na.encode = FALSE)

  df_data <- df %>%
    select(Study,
           ShortResearchID = Participant_ID,
           DELV_Variation_Completion = maybe_starts_with("DELV_Date"),
           DELV_Variation_ColumnA = maybe_starts_with("DELV_LanguageVar_ColumnAScore"),
           DELV_Variation_ColumnB = maybe_starts_with("DELV_LanguageVar_ColumnBScore"),
           DELV_Variation_Degree = maybe_matches("DELV_DegreeLanguageVar"),
           DELV_Risk_Score = maybe_starts_with("DELV_LanguageRisk_DiagnosticErrorScore"),
           DELV_Risk_Degree = maybe_matches("DELV_LanguageRisk$")) %>%
    type_convert(cols_types) %>%
    # Convert the date to a string
    mutate_at(vars(ends_with("Completion")), format_if_exists)

  # Task not administered in every study, so return an empty dataframe if
  # no data found
  no_data <- identical(names(df_data), c("Study", "ShortResearchID"))
  if (no_data) {
    df_data <- data_frame()
  }

  df_data
}

replace_na_strings <- function(xs) ifelse(xs == "NA", NA, xs)

df_scores <- c(t1, t2, t3, ci1, ci2, cim, lt, medu, dialect) %>%
  lapply(process_delv_scores) %>%
  bind_rows() %>%
  # Spreadsheets have only one date for the two subtests, so have the risk test
  # borrow the variation date.
  mutate(DELV_Risk_Completion = DELV_Variation_Completion) %>%
  mutate_all(replace_na_strings)

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

df_scores <- df_scores %>%
  left_join(df_cds) %>%
  mutate(
    DELV_Variation_Age = chrono_age(Birthdate, DELV_Variation_Completion),
    DELV_Risk_Age = chrono_age(Birthdate, DELV_Risk_Completion))

# Keep only rows for a subtest if that subtest has scores
df_risk <- df_scores %>%
  filter(!is.na(DELV_Risk_Degree)) %>%
  select(ChildStudyID, Study, ShortResearchID, starts_with("DELV_Risk")) %>%
  print(n = Inf)

df_variation <- df_scores %>%
  filter(!is.na(DELV_Variation_ColumnA)) %>%
  select(ChildStudyID, Study, ShortResearchID,
         starts_with("DELV_Variation")) %>%
  print(n = Inf)


df_risk %>%
  distinct(DELV_Risk_Age, DELV_Risk_Score, DELV_Risk_Degree) %>%
  arrange(DELV_Risk_Age, DELV_Risk_Score) %>%
  print(n = Inf)

df_risk_key <- data_frame(
  DELV_Risk_Degree = 0:3,
  DELV_Risk_Result = c("Lowest risk", "Low to medium risk",
                       "Medium to high risk", "High risk")
)

df_risk <- left_join(df_risk, df_risk_key)
print(df_risk, n = Inf)

df_variation_key <- data_frame(
  DELV_Variation_Degree = 0:2,
  DELV_Variation_Result = c("MAE", "Some variation from MAE",
                            "Strong variation from MAE")
)

df_variation <- left_join(df_variation, df_variation_key)
glimpse(df_variation)


delv_scores <- list(DELV_Risk = df_risk, DELV_Variation = df_variation)

# Make sure every DELV corresponds to a database ChildStudy key
delv_scores %>%
  lapply(. %>% filter(is.na(ChildStudyID)))

# No double counted scores
delv_scores %>%
  lapply(. %>% count(Study, ShortResearchID) %>% filter(n != 1))

## Compare local table with remote table and update database
df_delv <- delv_scores[[1]]
delv_name <- names(delv_scores)[1]

add_new_delv_scores <- function(df_delv, delv_name) {
  # Subtract current rows from new rows to see what data is new
  df_current_rows <- collect(delv_name %from% l2t)

  # Find completely new records that need to be added
  df_to_add <- find_new_rows_in_table(
    data = df_delv,
    ref_data = df_current_rows,
    required_cols = "ChildStudyID")

  append_rows_to_table(l2t, delv_name, df_to_add)
}

add_new_delv_scores(delv_scores$DELV_Risk, "DELV_Risk")
add_new_delv_scores(delv_scores$DELV_Variation, "DELV_Variation")

tbl(l2t, "DELV_Risk")
tbl(l2t, "DELV_Variation")



#
# ## Find records that need to be updated
#
# # Redownload the table
# df_remote <- collect("VerbalFluency" %from% l2t)
#
# # Attach the database keys to latest local data
# df_remote_indices <- df_remote %>%
#   select(ChildStudyID, VerbalFluencyID)
#
# df_local <- df_can_be_added %>%
#   inner_join(df_remote_indices) %>%
#   arrange(VerbalFluencyID)
#
# # Keep just the columns in the latest data (i.e., drop database-oriented
# # VerbalFluency_Timestamp)
# df_remote <- match_columns(df_remote, df_local) %>%
#   filter(ChildStudyID %in% df_local$ChildStudyID)
#
# # Preview changes with daff
# library("daff")
# daff <- diff_data(df_remote, df_local, context = 0)
# render_diff(daff)
#
# # Or see them itemized in a long data-frame
# create_diff_table(df_local, df_remote, "VerbalFluencyID")
#
# overwrite_rows_in_table(l2t, "VerbalFluency", rows = df_local, preview = TRUE)
# overwrite_rows_in_table(l2t, "VerbalFluency", rows = df_local, preview = FALSE)
#
# # Check one last time
# df_remote <- collect("VerbalFluency" %from% l2t)
# anti_join(df_remote, df_local, by = "VerbalFluencyID")
# anti_join(df_remote, df_local)
# anti_join(df_local, df_remote)
# anti_join(df_can_be_added, df_remote)
# anti_join(df_remote, df_can_be_added)
#
