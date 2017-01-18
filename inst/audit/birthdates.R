# Check birthdates in database

library("L2TDatabase")
library("dplyr")
library("tidyr")
library("readr")
# library("stringr")

# Load external dependencies
source("inst/paths.R")
source("inst/migrations/dates.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
# l2t_dl <- l2t_backup(l2t, "inst/backup")

# Collect dates
df_dates <- collect_dates(paths$score_dates, recursive = TRUE)


cds <- tbl(l2t, "Child") %>%
  left_join(tbl(l2t, "ChildStudy")) %>%
  left_join(tbl(l2t, "Study")) %>%
  select(ChildID, Study, ParticipantID = ShortResearchID, Birthdate) %>%
  collect()

df_dobs <- df_dates %>%
  filter(Variable == "DOB") %>%
  select(Study, ParticipantID, Birthdate = Value) %>%
  type_convert(col_types = cols(Birthdate = col_date())) %>%
  mutate(Source = "DIRT",
         Birthdate = format(Birthdate)) %>%
  left_join(select(cds, -Birthdate))

df_db_dobs <- cds %>% mutate(Source = "Database")

df_both <- bind_rows(df_dobs, df_db_dobs) %>%
  spread(Source, Birthdate)

df_both %>%
  filter(!is.na(Database), Database != DIRT) %>%
  arrange(Study, ParticipantID)

df_both %>%
  filter(!is.na(Database), Database != DIRT) %>%
  arrange(ParticipantID, Study)

