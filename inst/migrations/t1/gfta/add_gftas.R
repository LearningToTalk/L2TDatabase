# Add Timepoint1 GFTA2 scores to the database

library("L2TDatabase")
library("dplyr")
library("readr")
library("stringr")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get child demographics
cds <- l2t_dl$Child %>%
  left_join(l2t_dl$ChildStudy) %>%
  left_join(l2t_dl$Study) %>%
  select(ChildStudyID, Study, ShortResearchID, Female, Birthdate) %>%
  filter(Study == "TimePoint1") %>%
  mutate(Gender = ifelse(Female == 1, "Female", NA),
         Gender = ifelse(Female == 0, "Male", Gender)) %>%
  select(-Female)

# Load transcription results. Recompute adjusted scores
gfta_scores <- read_csv("inst/migrations/t1/gfta/gfta_2016-03-22.csv") %>%
  select(-testAge, normScore) %>%
  mutate(Study = "TimePoint1",
         ShortResearchID = str_extract(pID, "\\d{3}[A-Z]"),
         AdjustedScore = (rawScore / numTrans) * 77,
         AdjustedScore = round(AdjustedScore),
         Score = 77 - AdjustedScore) %>%
  select(-pID) %>%
  rename(TestDate = testDate, RawScore = rawScore, NumTrans = numTrans)

stopifnot(all(gfta_scores$normScore == gfta_scores$AdjustedScore))

# Add demographics. Compute test age
with_demographics <- gfta_scores %>%
  left_join(cds) %>%
  mutate(Age = chrono_age(Birthdate, TestDate))

# Download norms
gfta_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("GFTA2") %>%
  collect

# Look up norms
with_norms <- with_demographics %>%
  left_join(gfta_norms)

stopifnot(all(with_norms$Standard == with_norms$standardScore))

# Format to match database
db_ready <- with_norms %>%
  select(ChildStudyID,
         GFTA_Completion = TestDate,
         GFTA_RawCorrect = RawScore,
         GFTA_NumTranscribed = NumTrans,
         GFTA_AdjCorrect = AdjustedScore,
         GFTA_AdjNumErrors = Score,
         GFTA_Standard = Standard,
         GFTA_Age = Age) %>%
  type_convert %>%
  # Dates should be strings for uploading
  mutate(GFTA_Completion = format(GFTA_Completion))

# hist(db_ready$GFTA_Standard)


# Find completely new records that need to be added
remote_version <- tbl(l2t, "GFTA") %>% collect %>% arrange(ChildStudyID)

to_add <- db_ready %>%
  anti_join(remote_version, by = "ChildStudyID") %>%
  arrange(ChildStudyID)

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "GFTA", to_add)


