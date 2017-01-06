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

# Get child demographics
df_cds <- l2t_dl$Child %>%
  left_join(l2t_dl$ChildStudy) %>%
  left_join(l2t_dl$Study) %>%
  select(ChildStudyID, Study, ShortResearchID, Female, Birthdate) %>%
  mutate(Gender = ifelse(Female == 1, "Female", NA),
         Gender = ifelse(Female == 0, "Male", Gender)) %>%
  select(-Female) %>%
  readr::type_convert()

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

# Extract the data of the GFTA from a participant-info spreadsheet, or return an
# empty dataframe if it cannot be found
get_gfta_date <- function(df) {
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
           GFTA_Completion = maybe_matches("GFTA_COMPLETION_DATE|GFTA_Date")) %>%
    type_convert(cols_types) %>%
    # Convert the date to a string
    mutate_at(vars(ends_with("Completion")), format_if_exists)

  # GFTA not administered in every study, so return an empty dataframe if no
  # data found
  no_data <- identical(names(df_data), c("Study", "ShortResearchID"))
  if (no_data) {
    df_data <- data_frame()
  }

  df_data
}

df_gfta_dates <- c(t1, t2, t3, ci1, ci2, cim, lt, medu) %>%
  lapply(get_gfta_date) %>%
  bind_rows()

# GFTAs per study
df_gfta_dates %>% filter(!is.na(GFTA_Completion)) %>% count(Study)


df_gfta_scores <- "./inst/migrations/gfta/2016-12-14-scores_per_study.csv" %>%
  readr::read_csv()

# Make sure the CochlearMatching kids have the correct Study name
cimatching_ids <- df_cds %>%
  filter(Study == "CochlearMatching") %>%
  getElement("ShortResearchID")

df_gfta_scores <- df_gfta_scores %>%
  mutate(Study = ifelse(ShortResearchID %in% cimatching_ids, "CochlearMatching", Study)) %>%
  left_join(df_gfta_dates)

df_gfta_scores %>% count(Study)

# Couldn't find dates
df_gfta_scores %>% filter(is.na(GFTA_Completion))


df_scores_with_dates <- df_gfta_scores %>%
  filter(!is.na(GFTA_Completion)) %>%
  rename(AdjustedScore = normScore, RawScore = rawScore,
         NumTrans = numTrans) %>%
  mutate(Score = 77 - AdjustedScore)

# Add demographics. Compute test age
df_with_demographics <- df_scores_with_dates %>%
  left_join(df_cds) %>%
  mutate(Age = chrono_age(Birthdate, GFTA_Completion))

# Download norms
df_gfta_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("GFTA2") %>%
  collect()

# The database will turn <40 into 0, so just make it 39.
df_gfta_norms$Standard <- df_gfta_norms$Standard %>%
  str_replace("<40", 39)

# Look up norms
df_with_norms <- df_with_demographics %>%
  left_join(df_gfta_norms)

df_with_norms %>% filter(is.na(Standard))


# Format to match database
df_can_be_added <- df_with_norms %>%
  select(ChildStudyID,
         GFTA_Completion,
         GFTA_RawCorrect = RawScore,
         GFTA_NumTranscribed = NumTrans,
         GFTA_AdjCorrect = AdjustedScore,
         GFTA_AdjNumErrors = Score,
         GFTA_Standard = Standard,
         GFTA_Age = Age) %>%
  readr::type_convert() %>%
  # Dates should be strings for uploading
  mutate(GFTA_Completion = format(GFTA_Completion))


# Find completely new records that need to be added
df_current_rows <- tbl(l2t, "GFTA") %>%
  collect() %>%
  arrange(ChildStudyID)

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = df_current_rows,
  required_cols = "ChildStudyID")

df_to_add %>% print(n = Inf)

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "GFTA", df_to_add)




## Find records that need to be updated

# Redownload the table
df_remote <- collect("GFTA" %from% l2t)

# Attach the database keys to latest data
df_remote_indices <- df_remote %>%
  select(ChildStudyID, GFTAID)

df_local <- df_can_be_added %>%
  inner_join(df_remote_indices) %>%
  arrange(GFTAID)

# Keep just the columns in the latest data
df_remote <- match_columns(df_remote, df_local) %>%
  filter(ChildStudyID %in% df_local$ChildStudyID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote, df_local, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote, "GFTAID")

overwrite_rows_in_table(l2t, "GFTA", rows = df_local, preview = TRUE)
overwrite_rows_in_table(l2t, "GFTA", rows = df_local, preview = FALSE)



# Check one last time
df_remote <- collect("GFTA" %from% l2t)
anti_join(df_remote, df_local, by = "GFTAID")
anti_join(df_remote, df_local)
anti_join(df_local, df_remote)
anti_join(df_can_be_added, df_remote)
anti_join(df_remote, df_can_be_added)
