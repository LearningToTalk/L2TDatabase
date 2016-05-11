## Create ChildStudy rows for the children who participated at TimePoint3

# Big overview: In our studies, we have a Child table (one row per child), a
# Study table (one row per study), a ChildStudy table (one row per assignment of
# a child in a study). All the experimental data and test scores belong to
# ChildStudy entries. To add brand new child, we have to create a new Child
# entry, and create a new ChildStudy entry to assign the child to a study.

# What we have to do: But because children who participated at TimePoint3 almost
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

# Data collect is ongoing. Need to be careful, and only create rows for
# participants that have visited the lab.
tp3_both <- GetSiteInfo(sheet = "TimePoint3", separately = TRUE)

tp3 <- tp3_both %>%
  lapply(function(x) select(x, Participant_ID, Cohort, EVT_GSV, `verbalfluency_raw_time5-6`, Cohort, AAE, female, Age = `AgeAtvA_5-6`)) %>%
  bind_rows

tp3_visited <- tp3 %>% filter(!is.na(Cohort))
tp3_visited

# Peek at the kids whom we think did not visit
tp3_no_cohort <- tp3 %>% filter(is.na(Cohort))
tp3_no_cohort$`verbalfluency_raw_time5-6`
tp3_no_cohort$EVT_GSV


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
stopifnot(is.element("TimePoint3", l2t_dl$Study$Study))

# What columns are used the ChildStudy table?
glimpse(l2t_dl$ChildStudy)

# We need to assemble the long research id (e.g., "001L39FS3") from available
# data
tp3_visited <- tp3_visited %>%
  rename(ShortResearchID = Participant_ID) %>%
  select(ShortResearchID, Cohort, AAE, female, Age) %>%
  mutate(Study = "TimePoint3", ProjectAbbrev = "L",
         Gender = ifelse(female, "F", "M"),
         Dialect = ifelse(AAE, "A", "S"))

# Check for NAs
lapply(tp3_visited, unique)
stopifnot(!any(is.na(tp3_visited$AAE)))
stopifnot(!any(is.na(tp3_visited$female)))
stopifnot(!any(is.na(tp3_visited$Age)))

# UMN appears to be using ages formatted with "months_cohort". I asked them not
# to do that. Fix it by truncating the string
tp3_visited$Age <- str_sub(tp3_visited$Age, 1, 2)

tp3_visited <- tp3_visited %>%
  filter(!is.na(female), !is.na(AAE), !is.na(Age)) %>%
  arrange(ShortResearchID)

# These are the new rows that need to be added the ChildStudy. They just need
# Child and Study id values attached to them.
tp3_final <- tp3_visited %>%
  mutate(ID = paste0(ShortResearchID, Age, Gender, Dialect, Cohort)) %>%
  select(ShortResearchID, FullResearchID = ID, Study)

# One row per participant
stopifnot(n_distinct(tp3_final$ShortResearchID) == nrow(tp3_final))

# Attach StudyID
tp3_final <- tp3_final %>%
  left_join(l2t_dl$Study) %>%
  select(ShortResearchID, FullResearchID, StudyID)

# Combine current Child-Study-ChildStudy tbls to get identifiers used by db
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Assuming that the same child is represented by the same ShortResearchID in the
# TimePoint1 and TimePoint3 studies, use the ShortResearchID to get the
# ChildID
tp1_ids <- cds %>%
  filter(Study == "TimePoint1") %>%
  select(ChildID, ShortResearchID)

# Check for kids in tp3 not in tp1
stopifnot(nrow(anti_join(tp3_final, tp1_ids)) == 0)

tp3_final <- tp3_final %>%
  left_join(tp1_ids) %>%
  arrange(ChildID)



## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect("ChildStudy" %from% l2t)
new_rows <- tp3_final %>%
  anti_join(current_rows, by = c("StudyID", "ChildID")) %>%
  arrange(ChildID)


# Add to database
append_rows_to_table(l2t, "ChildStudy", new_rows)

## Compare remote to local

# Subtract current table from rows-just-added. Result should be empty if every
# row-just-added has a match in remote table.
remote_data <- collect("ChildStudy" %from% l2t)
updated_rows <- anti_join(new_rows, remote_data)
updated_rows


## Find records that need to be updated

# Compare the local and remote data to find fields with different values

# Attach the database keys to latest data
current_indices <- remote_data %>%
  select(ChildStudyID, StudyID, ChildID)

latest_data <- tp3_final %>%
  inner_join(current_indices)

# Keep just the columns in the latest data
remote_data <- match_columns(remote_data, latest_data) %>%
  filter(ChildStudyID %in% latest_data$ChildStudyID)

# Now, we have 2 tables with our latest local data and the current remote data,
# and the tables have same columns and the same database keys. Now we can
# compare cells between to the two tables and find updated records.

# Preview changes with daff
library("daff")
daff <- diff_data(remote_data, latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "ChildStudyID")

# Send a SQL query to update the record
overwrite_rows_in_table(l2t, "ChildStudy", rows = latest_data, preview = TRUE)
# overwrite_rows_in_table(l2t, "ChildStudy", rows = latest_data, preview = FALSE)

# Subtract remote from local. Should be no differences left.
remote_data <- collect("ChildStudy" %from% l2t)
tp3_final %>%
  anti_join(remote_data) %>%
  arrange(ChildID)
