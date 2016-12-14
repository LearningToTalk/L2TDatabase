library("L2TDatabase")
library("dplyr")
library("tidyr")
library("stringr")

# Load external dependencies
source("inst/paths.R")
source("inst/migrations/dates.R")


# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get child demographics
cds <- l2t_dl$Child %>%
  left_join(l2t_dl$ChildStudy) %>%
  left_join(l2t_dl$Study) %>%
  select(ChildStudyID, Study, ShortResearchID, Female, Birthdate) %>%
  mutate(Gender = ifelse(Female == 1, "Female", NA),
         Gender = ifelse(Female == 0, "Male", Gender)) %>%
  select(-Female) %>%
  readr::type_convert()

# Collect dates/scores
df_dates <- collect_dates(paths$score_dates, recursive = TRUE) %>%
  filter(Study != "Dialect")

df_gfta_dates <- df_dates %>%
  filter(str_detect(Variable, "GFTA.Date")) %>%
  rename(GFTA_Completion = Value) %>%
  readr::type_convert() %>%
  rename(ShortResearchID = ParticipantID) %>%
  select(Study, ShortResearchID, GFTA_Completion) %>%
  mutate(Study = ifelse(Study == "Medu", "MaternalEd", Study))

df_gfta_scores <- "./inst/migrations/gfta/2016-12-14-scores_per_study.csv" %>%
  readr::read_csv() %>%
  left_join(df_gfta_dates)

# Couldn't find dates
df_gfta_scores %>% filter(is.na(GFTA_Completion))


df_gfta_scores <- df_gfta_scores %>%
  filter(!is.na(GFTA_Completion)) %>%
  rename(AdjustedScore = normScore, RawScore = rawScore,
         NumTrans = numTrans) %>%
  mutate(Score = 77 - AdjustedScore)

# Add demographics. Compute test age
with_demographics <- df_gfta_scores %>%
  left_join(cds) %>%
  mutate(Age = chrono_age(Birthdate, GFTA_Completion))

# Download norms
gfta_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("GFTA2") %>%
  collect()

# Look up norms
with_norms <- with_demographics %>%
  left_join(gfta_norms)

# The database will turn <40 into 0, so just make it 39.
with_norms$Standard <- with_norms$Standard %>%
  str_replace("<40", 39)

# Format to match database
db_ready <- with_norms %>%
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
remote_version <- tbl(l2t, "GFTA") %>% collect %>% arrange(ChildStudyID)

to_add <- db_ready %>%
  anti_join(remote_version, by = "ChildStudyID") %>%
  arrange(ChildStudyID)

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "GFTA", to_add)


# Find updated rows

## Find records that need to be updated

# Redownload the table
remote_data <- collect("GFTA" %from% l2t)

# Attach the database keys to latest data
current_indices <- remote_data %>%
  select(ChildStudyID, GFTAID)

latest_data <- db_ready %>%
  inner_join(current_indices)

# Keep just the columns in the latest data
remote_data <- match_columns(remote_data, latest_data) %>%
  filter(ChildStudyID %in% latest_data$ChildStudyID)

# Preview changes with daff
library("daff")
daff <- diff_data(remote_data, latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "GFTAID")

overwrite_rows_in_table(l2t, "GFTA", rows = latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "GFTA", rows = latest_data, preview = FALSE)


