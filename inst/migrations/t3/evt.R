# Add timepoint3 evt scores to the database

library("L2TDatabase")
library("dplyr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo, chdir = TRUE)

# # Peek at the excel spreadsheet
# open_file <- function(file_name) shell(sprintf("open %s", file_name))
# open_file(uw_info_path)
# open_file(umn_info_path)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Treat "NA" and NA identically
convert_na_strings <- function(xs) ifelse(is_na_string(xs), NA, xs)
is_na_string <- function(xs) is.element(xs, c(NA, "NA"))

# Get T3 scores for both sites. Function sourced via paths$GetSiteInfo
t3 <- GetSiteInfo(sheet = "TimePoint3")


# Get the EVT columns for a spreadsheet
t3_evt <- t3 %>%
  select(ShortResearchID = Participant_ID, EVT_Form,
         EVT_Completion = starts_with("EVT_COMPLETION"),
         EVT_Raw = starts_with("EVT_raw"),
         EVT_Standard = starts_with("EVT_standard"),
         EVT_GSV) %>%
  mutate(Study = "TimePoint3",
         EVT_Completion = format(EVT_Completion))

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the EVT scores. Keep only rows of children
# with corresponding rows in the ChildStudy table
with_evt <- inner_join(t3_evt, cds)

# Calculate chronological ages, default to NA if error encountered
chr_age <- failwith(NA, chrono_age)

with_evt <- with_evt %>%
  mutate(EVT_Age = unlist(Map(chr_age, EVT_Completion, Birthdate)))

# Find completely new records that need to be added
latest_data <- match_columns(with_evt, l2t_dl$EVT) %>%
  arrange(ChildStudyID)

to_add <- latest_data %>%
  anti_join(tbl(l2t, "EVT"), by = c("ChildStudyID"), copy = TRUE) %>%
  arrange(ChildStudyID)




# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "EVT", to_add)



## Find records that need to be updated

# Redownload the table
remote_data <- collect("EVT" %from% l2t)

# Attach the database keys to latest data
current_indices <- remote_data %>%
  select(ChildStudyID, EVTID)

latest_data <- latest_data %>%
  inner_join(current_indices)

# Keep just the columns in the latest data
remote_data <- match_columns(remote_data, latest_data) %>%
  filter(ChildStudyID %in% latest_data$ChildStudyID)

# Preview changes with daff
library("daff")
daff <- diff_data(remote_data, latest_data, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "EVTID")

overwrite_rows_in_table(l2t, "EVT", rows = latest_data, preview = TRUE)
# overwrite_rows_in_table(l2t, "EVT", rows = latest_data, preview = FALSE)


