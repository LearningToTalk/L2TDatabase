# Add timepoint2 ppvt scores to the database

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

# Get T2 scores for both sites. Function sourced via paths$GetSiteInfo
t2 <- GetSiteInfo(sheet = "TimePoint2", separately = TRUE)

# Fix the dates in each spreadsheet to the same type and format
clean_excel_dates <- . %>%
  convert_na_strings %>%
  undo_excel_date %>%
  format

clean_dates <- function(dates) {
  f <- if (inherits(dates, "POSIXt")) format else clean_excel_dates
  f(dates)
}

t2$UW$PPVT_COMPLETION_DATE <- t2$UW$PPVT_COMPLETION_DATE %>% clean_dates
t2$UMN$PPVT_COMPLETION_DATE <- t2$UMN$PPVT_COMPLETION_DATE %>% clean_dates

# Get the PPVT columns for a spreadsheet
get_ppvt_part <- . %>%
  select(ShortResearchID = Participant_ID,
         PPVT_Form,
         PPVT_Completion = starts_with("PPVT_COMPLETION"),
         PPVT_Raw = starts_with("PPVT_raw"),
         PPVT_Standard = starts_with("PPVT_standard"),
         PPVT_GSV) %>%
  # Make sure scores are integers
  mutate_each(funs(as.integer(.)), PPVT_Raw:PPVT_GSV) %>%
  mutate(Study = "TimePoint2")

# Extract and combine the PPVT columns from the spreadsheets
t2_ppvt <- t2 %>%
  lapply(get_ppvt_part) %>%
  bind_rows

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the PPVT scores. Keep only rows of children
# with corresponding rows in the ChildStudy table
with_ppvt <- inner_join(t2_ppvt, cds)

# Determine chronological age at test data
with_ppvt <- with_ppvt %>%
  mutate(PPVT_Age = chrono_age(PPVT_Completion, Birthdate))

# Find completely new records that need to be added
latest_data <- match_columns(with_ppvt, l2t_dl$PPVT) %>%
  arrange(ChildStudyID)

to_add <- latest_data %>%
  anti_join(l2t_dl$PPVT, by = c("ChildStudyID")) %>%
  arrange(ChildStudyID)
to_add



# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "PPVT", to_add)



## Find records that need to be updated

# Redownload the table
remote_data <- collect("PPVT" %from% l2t)

# Attach the database keys to latest data
current_indices <- remote_data %>%
  select(ChildStudyID, PPVTID)

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
create_diff_table(latest_data, remote_data, "PPVTID")

overwrite_rows_in_table(l2t, "PPVT", rows = latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "PPVT", rows = latest_data, preview = FALSE)




