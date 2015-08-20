# Add timepoint1 evt scores to the database

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
t1_evt <- t1 %>%
  select(ShortResearchID = Participant_ID,
         EVT_Form,
         EVT_Completion = starts_with("EVT_COMPLETION"),
         EVT_Raw = starts_with("EVT_raw"),
         EVT_Standard = starts_with("EVT_standard"),
         EVT_GSV) %>%
  # Make sure scores are integers
  mutate_each(funs(as.integer(.)), EVT_Raw:EVT_GSV) %>%
  mutate(Study = "TimePoint1")

# Convert dates
t1_evt$EVT_Completion <- t1_evt$EVT_Completion %>%
  convert_na_strings %>%
  undo_excel_date %>%
  format

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the EVT scores
with_evt <- left_join(t1_evt, cds)

# Calculate chronological ages, default to NA if error encountered
chr_age <- failwith(NA, chrono_age)
with_evt <- with_evt %>%
  mutate(EVT_Age = unlist(Map(chr_age, EVT_Completion, Birthdate)))

# Remove duplicate rows (any row with matching ChildStudyID and EVT_Completion
# values)
current_rows <- l2t_dl$EVT
current_empties <- filter(current_rows, is.na(EVT_Completion))

to_add <- with_evt %>%
  anti_join(current_rows, by = c("ChildStudyID", "EVT_Completion")) %>%
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
