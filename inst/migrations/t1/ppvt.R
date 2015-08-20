# Add timepoint1 ppvt scores to the database

library("L2TDatabase")
library("dplyr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Treat "NA" and NA identically
convert_na_strings <- function(xs) ifelse(is_na_string(xs), NA, xs)
is_na_string <- function(xs) is.element(xs, c(NA, "NA"))

# Get T1 scores for both sites. Function sourced via paths$GetSiteInfo
t1 <- GetSiteInfo()
names(t1)
t1_ppvt <- t1 %>%
  select(ShortResearchID = Participant_ID,
         PPVT_Form,
         PPVT_Completion = starts_with("PPVT_COMPLETION"),
         PPVT_Raw = starts_with("PPVT_raw"),
         PPVT_Standard = starts_with("PPVT_standard"),
         PPVT_GSV) %>%
  # Make sure scores are integers
  mutate_each(funs(as.integer(.)), PPVT_Raw:PPVT_GSV) %>%
  mutate(Study = "TimePoint1")

# Convert dates
unique(t1_ppvt$PPVT_Completion)
t1_ppvt$PPVT_Completion <- t1_ppvt$PPVT_Completion %>%
  convert_na_strings %>%
  undo_excel_date %>%
  format

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the PPVT scores
with_ppvt <- left_join(t1_ppvt, cds)

# Calculate chronological ages, default to NA if error encountered
chr_age <- failwith(NA, chrono_age)
with_ppvt <- with_ppvt %>%
  mutate(PPVT_Age = unlist(Map(chr_age, PPVT_Completion, Birthdate)))

# Remove duplicate rows (any row with matching ChildStudyID and PPVT_Completion
# values)
current_rows <- l2t_dl$PPVT
current_empties <- filter(current_rows, is.na(PPVT_Completion))

to_add <- with_ppvt %>%
  anti_join(current_rows, by = c("ChildStudyID", "PPVT_Completion")) %>%
  # In case the doesn't work on NA completion dates, keep rows with matching ids
  # but blank completion dates from being added.
  anti_join(current_empties, by = c("ChildStudyID"))

# Choose final columns and update rows
to_add <- match_columns(to_add, current_rows) %>%
  arrange(ChildStudyID)
to_add

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "PPVT", to_add)
