# Check birthdates in database

library("L2TDatabase")
library("dplyr")
library("tidyr")
# library("stringr")

# Load external dependencies
source("inst/paths.R")
source("inst/migrations/dates.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
# l2t_dl <- l2t_backup(l2t, "inst/backup")

# Collect dates
df_dates <- collect_dates(paths$score_dates, recursive = TRUE)



df_dobs <- df_dates %>%
  filter(Variable == "DOB") %>%
  select(Study, ParticipantID, Birthdate = Value) %>%
  mutate(Source = "DIRT",
         Birthdate = format(Birthdate))

df_db_dobs <- tbl(l2t, "Child") %>%
  left_join(tbl(l2t, "ChildStudy")) %>%
  left_join(tbl(l2t, "Study")) %>%
  select(Study, ParticipantID = ShortResearchID, Birthdate) %>%
  collect %>%
  mutate(Source = "Database")

df_both <- bind_rows(df_dobs, df_db_dobs) %>%
  spread(Source, Birthdate)

df_both %>%
  filter(!is.na(Database), Database != DIRT) %>%
  arrange(Study, ParticipantID)
