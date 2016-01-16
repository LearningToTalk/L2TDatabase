# Add timepoint2 evt scores to the database

library("L2TDatabase")
library("dplyr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo)

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

# Get T2 scores for both sites. Function sourced via paths$GetSiteInfo
t2 <- GetSiteInfo(sheet = "TimePoint2", separately = TRUE)

# Fix the dates in each spreadsheet to the same type and format
t2$UW$EVT_COMPLETION_DATE <-
  t2$UW$EVT_COMPLETION_DATE %>%
  convert_na_strings %>%
  undo_excel_date %>%
  format
t2$UMN$EVT_COMPLETION_DATE <- t2$UMN$EVT_COMPLETION_DATE %>% format()

# Get the EVT columns for a spreadsheet
get_evt_part <- . %>%
  select(ShortResearchID = Participant_ID,
         EVT_Form,
         EVT_Completion = starts_with("EVT_COMPLETION"),
         EVT_Raw = starts_with("EVT_raw"),
         EVT_Standard = starts_with("EVT_standard"),
         EVT_GSV) %>%
  # Make sure scores are integers
  mutate_each(funs(as.integer(.)), EVT_Raw:EVT_GSV) %>%
  mutate(Study = "TimePoint2")

# Extract and combine the EVT columns from the spreadsheets
t2_evt <- t2 %>%
  lapply(get_evt_part) %>%
  bind_rows


# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the EVT scores. Keep only rows of children
# with corresponding rows in the ChildStudy table
with_evt <- inner_join(t2_evt, cds)

# Calculate chronological ages, default to NA if error encountered
chr_age <- failwith(NA, chrono_age)

with_evt <- with_evt %>%
  mutate(EVT_Age = unlist(Map(chr_age, EVT_Completion, Birthdate)))

# Find completely new records that need to be added
latest_data <- match_columns(with_evt, l2t_dl$EVT) %>%
  arrange(ChildStudyID)

to_add <- latest_data %>%
  anti_join(l2t_dl$EVT, by = c("ChildStudyID")) %>%
  arrange(ChildStudyID)




# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "EVT", to_add)



## Find records that need to be updated

# # Redownload the table
# current_data <- collect("EVT" %from% l2t)
#
# # Attach the database keys to latest data
# current_indices <- current_data %>%
#   select(ChildStudyID, EVTID)
#
# latest_data <- latest_data %>%
#   inner_join(current_indices)
#
# # Keep just the columns in the latest data
# current_data <- match_columns(current_data, latest_data) %>%
#   filter(ChildStudyID %in% latest_data$ChildStudyID)
#
# # Preview changes with daff
# library("daff")
# daff <- diff_data(current_data, latest_data, context = 0)
# render_diff(daff)
#
# # Or see them itemized in a long data-frame
# create_diff_table(latest_data, current_data, "EVTID")
#
# merge_values_into_table(l2t, "EVT", rows = latest_data, preview = TRUE)
# merge_values_into_table(l2t, "EVT", rows = latest_data, preview = FALSE)

