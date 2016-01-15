## Create ChildStudy rows for the children who participated at TimePoint2

# Big overview: In our studies, we have a Child table (one row per child), a
# Study table (one row per study), a ChildStudy table (one row per assignment of
# a child in a study). All the experimental data and test scores belong to
# ChildStudy entries. To add brand new child, we have to create a new Child
# entry, and create a new ChildStudy entry to assign the child to a study.

# What we have to do: But because children who participated at TimePoint2 almost
# certainly participated at TimePoint1, we don't worry about creating new
# entries in the Child table. Instead, we just look-up the Child info using
# their ChildStudy info from TimePoint1, and add the children as new entries in
# the ChildStudy table.

library("L2TDatabase")
library("readxl")
library("dplyr")
library("tidyr")
library("stringr")

# A non-version-controlled file containing paths to the source data
source("inst/paths.R")

# Helpers for working with the Excel participant-info spreadsheets
source(paths$GetSiteInfo)

# # Peek at the excel spreadsheet
# open_file <- function(file_name) shell(sprintf("open %s", file_name))
# open_file(uw_info_path)
# open_file(umn_info_path)

# UW is done with TP2, so all rows are usable. UMN copied all rows from TP1 over
# and filled in the data as participants visited the lab. The rows with NA
# values for the Cohort column are children who did not visit lab (yet).
tp2 <- GetSiteInfo(sheet = "TimePoint2")
tp2_visited <- tp2 %>% filter(!is.na(Cohort))

# A non-version-controlled file with db connection info and credentials
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")

# Other parameters for migration
db_name <- "l2t"
backup_dir <- "inst/backup"

# Connect and download each table to csv
l2t <- l2t_connect(cnf_file, db_name)
l2t_dl <- l2t_backup(l2t, backup_dir)

# If MySQL is available on the command line, dump the database too
dump_database(cnf_file, backup_dir, db_name)

# Does the study exist?
l2t_dl$Study
stopifnot(is.element("TimePoint2", l2t_dl$Study$Study))

# What columns are used the ChildStudy table?
glimpse(l2t_dl$ChildStudy)

# We need to assemble the long research id (e.g., "001L39FS3") from available
# data
tp2_visited <- tp2_visited %>%
  rename(ShortResearchID = Participant_ID) %>%
  select(ShortResearchID, Cohort, AAE, female, Age = `AgeAtvA_3-4`) %>%
  mutate(Study = "TimePoint2", ProjectAbbrev = "L",
         Gender = ifelse(female, "F", "M"),
         Dialect = ifelse(AAE, "A", "S"))

# Check for NAs
lapply(tp2_visited, unique)

# UMN appears to be using ages formatted with "months_cohort". I asked them not
# to do that. Fix it by truncating the string
tp2_visited$Age <- str_sub(tp2_visited$Age, 1, 2)

tp2_visited <- tp2_visited %>%
  filter(!is.na(female), !is.na(AAE), !is.na(Age)) %>%
  arrange(ShortResearchID)

# These are the new rows that need to be added the ChildStudy. They just need
# Child and Study id values attached to them.
tp2_final <- tp2_visited %>%
  mutate(ID = paste0(ShortResearchID, Age, Gender, Dialect, Cohort)) %>%
  select(ShortResearchID, FullResearchID = ID, Study)

# One row per participant
stopifnot(n_distinct(tp2_final$ShortResearchID) == nrow(tp2_final))

# Attach StudyID
tp2_final <- tp2_final %>%
  left_join(l2t_dl$Study) %>%
  select(ShortResearchID, FullResearchID, StudyID)

# Combine current Child-Study-ChildStudy tbls to get identifiers used by db
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Assuming that the same child is represented by the same ShortResearchID in the
# TimePoint1 and TimePoint2 studies, use the ShortResearchID to get the
# ChildStudyID
tp1_ids <- cds %>%
  filter(Study == "TimePoint1") %>%
  select(ChildID, ShortResearchID)

# Check for kids in tp2 not in tp1
stopifnot(nrow(anti_join(tp2_final, tp1_ids)) == 0)

tp2_final <- tp2_final %>%
  left_join(tp1_ids) %>%
  arrange(ChildID)



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect("ChildStudy" %from% l2t)
new_rows <- anti_join(tp2_final, current_rows) %>%
  arrange(ChildID)

# Add to database
append_rows_to_table(l2t, "ChildStudy", new_rows)

## Compare remote to local

# Subtract current table from rows-just-added. Result should be empty if every
# row-just-added has a match in remote table.
updated_rows <- anti_join(new_rows, collect("ChildStudy" %from% l2t))
updated_rows


