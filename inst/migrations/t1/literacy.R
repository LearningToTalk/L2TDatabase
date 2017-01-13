# Add TimePoint1 literacy scores to the database

library("L2TDatabase")
library("dplyr")
library("stringr")
library("lubridate")
library("readr")

# Load external dependencies
source("inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

dump_database(
  cnf_file = cnf_file,
  backup_dir = "inst/backup",
  db_name = "l2t")


df_lit <- paths$literacy_results %>%
  read_csv %>%
  rename(ShortResearchID = Participant_ID) %>%
  mutate(ShortResearchID = str_sub(ShortResearchID, 1, 4))

df_lit %>% lapply(unique) %>% lapply(sort)

# Examine duplicated IDs
dupes <- df_lit %>%
  count(ShortResearchID) %>%
  filter(1 < n)

df_lit %>%
  filter(ShortResearchID %in% other_dupes$ShortResearchID) %>%
  arrange(ShortResearchID)

# We want to keep the most-complete survey data, and if they are both complete,
# keep the earliest one. Here we hand-code a dataframe on entries to drop and
# exclude them with an antijoin.
drop_df <- data_frame(
  ShortResearchID = c("005L", "008L", "076L",
                      "622L", "624L", "673L",
                      "677L"),
  SurveyDatetime = c("10/24/2012 10:44", "1/25/2013 18:09", "1/7/2014 14:13",
                     "3/9/2013 13:04", "3/11/2013 11:09", "8/4/2014 13:22",
                     "8/4/2014 20:32")
)

df_lit <- anti_join(df_lit, drop_df)


# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the name of the Study and use an inner join to keep only the kids with
# survey data who also appear in the Study==TimePoint1 rows of cds. This will
# filter out all the cross-sectional children.
df_lit <- df_lit %>% mutate(Study = "TimePoint1")
kids_with_surveys <- inner_join(df_lit, cds) %>%
  # Convert strings to Dates to unambiguous formats
  mutate(SurveyDatetime = mdy_hm(SurveyDatetime) %>% as.character)




## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
dest_table <- "Literacy"
current_rows <- collect(dest_table %from% l2t)
new_rows <- anti_join(kids_with_surveys, current_rows)
new_rows

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(ChildStudyID)
to_add

# Add to database
append_rows_to_table(l2t, dest_table, to_add)




## Compare remote to local
updated_rows <- anti_join(to_add, collect(dest_table %from% l2t))
updated_rows

