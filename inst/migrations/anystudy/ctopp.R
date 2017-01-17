# Add CTOPP scores to the database
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

df <- t3$UW
# Select the VerbalFluency columns if they exist, otherwise return a blank
# dataframe
process_ctopp_scores <- function(df) {
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
           CTOPPElision_Completion = maybe_starts_with("CTOPPElision_Date"),
           CTOPPElision_Raw = maybe_matches("CTOPP_Elision_raw|CTOPPElision_Raw"),
           CTOPPElision_Scaled = maybe_matches("CTOPP_Elision_scaled|CTOPPElision_Scaled"),
           CTOPPBlending_Completion = maybe_starts_with("CTOPPBlending_Date"),
           CTOPPBlending_Raw = maybe_matches("CTOPP_Blending_raw|CTOPPBlending_Raw"),
           CTOPPBlending_Scaled = maybe_matches("CTOPP_Blending_scaled|CTOPPBlending_Scaled"),
           CTOPPMemory_Completion = maybe_matches("CTOPP_MemoryforDigits_COMPLETION|CTOPPMemory_Date"),
           CTOPPMemory_Raw = maybe_matches("CTOPP_MemoryforDigits_raw|CTOPPMemory_Raw"),
           CTOPPMemory_Scaled = maybe_matches("CTOPP_MemoryforDigits_scaled|CTOPPMemory_Scaled")) %>%
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
  lapply(process_ctopp_scores) %>%
  bind_rows() %>%
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
    CTOPPBlending_Age = chrono_age(Birthdate, CTOPPBlending_Completion),
    CTOPPElision_Age = chrono_age(Birthdate, CTOPPElision_Completion),
    CTOPPMemory_Age = chrono_age(Birthdate, CTOPPMemory_Completion))

# Make sure every verbal fluency corresponds to a database ChildStudy key
df_scores %>%
  filter(is.na(ChildStudyID)) %>%
  print(n = Inf)


df_scores <- df_scores %>% select(-ChildStudyID, -Birthdate)

# Convert to long format
df_scores_long <- df_scores %>%
  gather(Variable, Value, -Study, -ShortResearchID) %>%
  separate(Variable, c("Test", "Variable")) %>%
  spread(Variable, Value) %>%
  mutate(Test = str_replace(Test, "CTOPP", "CTOPP_"))


df_scores_long %>%
  filter(is.na(Completion)) %>%
  filter(!is.na(Raw))

df_scores_long %>%
  filter(is.na(Raw)) %>%
  filter(!is.na(Completion))

# Drop empty values
df_scores_long <- df_scores_long %>% filter(!is.na(Completion))

# Check against test norms
db_norms <- l2t_connect(cnf_file, "norms")
get_norms_table <- function(test_name, db = db_norms) {
  tbl(db, test_name) %>%
    mutate(Test = test_name) %>%
    collect()
}

df_norms <- list("CTOPP_Blending", "CTOPP_Elision", "CTOPP_Memory") %>%
  lapply(get_norms_table) %>%
  bind_rows() %>%
  select(Test, Age, Raw, Scaled)

df_scores_long %>%
  type_convert() %>%
  left_join(df_norms, by = c("Test", "Age", "Raw")) %>%
  filter(Scaled.x != Scaled.y)


# Create a list of data-frames for scores from each test
ctopp_scores <- df_scores_long %>%
  gather(Variable, Value, Completion, Raw, Scaled, Age) %>%
  split(.$Test) %>%
  lapply(. %>%
           unite(Variable, Test, Variable) %>%
           spread(Variable, Value) %>%
           type_convert())




# Norm check

# No double counted scores
ctopp_scores %>%
  lapply(. %>% count(Study, ShortResearchID) %>% filter(n != 1))


# Add IDs
ctopp_scores_can_be_added <- ctopp_scores %>%
  lapply(. %>%
           inner_join(df_cds) %>%
           select(-Study, -ShortResearchID, -Birthdate))




## Compare local table with remote table and update database
df_ctopp <- ctopp_scores_can_be_added[[1]]
ctopp_name <- names(ctopp_scores_can_be_added)[1]

add_new_ctopp_scores <- function(df_ctopp, ctopp_name) {
  # Subtract current rows from new rows to see what data is new
  df_current_rows <- collect(ctopp_name %from% l2t)

  # Find completely new records that need to be added
  df_to_add <- find_new_rows_in_table(
    data = df_ctopp,
    ref_data = df_current_rows,
    required_cols = "ChildStudyID")

  append_rows_to_table(l2t, ctopp_name, df_to_add)
}


add_new_ctopp_scores(ctopp_scores_can_be_added$CTOPP_Blending, "CTOPP_Blending")
add_new_ctopp_scores(ctopp_scores_can_be_added$CTOPP_Memory, "CTOPP_Memory")
add_new_ctopp_scores(ctopp_scores_can_be_added$CTOPP_Elision, "CTOPP_Elision")






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
