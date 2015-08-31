# Add timepoint1 BRIEF scores to the database

library("L2TDatabase")
library("dplyr")
library("stringr")

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
t1 <- GetSiteInfo("BRIEFScores")

# Make spreadsheet names match the db version
names(t1) <- names(t1) %>%
  str_replace("_raw$", "_Raw") %>%
  str_replace("_T$", "_TScore") %>%
  str_replace("_percentile", "_Percentile")

# Check how names line up
names(t1)[names(t1) %in% colnames("BRIEF" %from% l2t)]
names(t1)[!names(t1) %in% colnames("BRIEF" %from% l2t)]

# UMN kept all inconsistency scores. UW only kept high inconsistency scores, so
# move inconsistency scores to notes column, lest we think a bunch of data is
# missing.
incon <- t1$InconsistencyScore
t1$BRIEF_Note <- ifelse(is.na(incon), NA, paste0("Inconsistency score: ", incon))

# Check values in each column. Want to know what strings are in the nominal
# score columns.
lapply(t1, unique)
lapply(t1, function(xs) str_subset(xs, "[A-z]"))

# Finish names and types of the score columns
t1 <- t1 %>%
  rename(ShortResearchID = Participant_ID,
         BRIEF_Completion = BRIEF_COMPLETION_DATE) %>%
  select(-Site, -InconsistencyScore) %>%
  # Make sure scores are integers
  mutate_each(funs(convert_na_strings)) %>%
  mutate_each(funs(as.integer), Inhibit_Raw:GEC_Percentile) %>%
  mutate(Study = "TimePoint1")

# Convert dates
t1$BRIEF_Completion <- t1$BRIEF_Completion %>%
  convert_na_strings %>%
  undo_excel_date %>%
  format

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the BRIEF scores
with_brief <- left_join(t1, cds)

# Check the raw data first
filter(with_brief, Inhibit_Raw + EC_Raw != ISCI_Raw) %>% glimpse
filter(with_brief, Inhibit_Raw + EC_Raw != ISCI_Raw)
filter(with_brief, Shift_Raw + EC_Raw != FI_Raw)
filter(with_brief, WM_Raw + PO_Raw != EMI_Raw)
filter(with_brief, Inhibit_Raw + Shift_Raw + EC_Raw + WM_Raw + PO_Raw != GEC_Raw) %>%
  select(ShortResearchID, Inhibit_Raw, Shift_Raw, EC_Raw, WM_Raw, PO_Raw, GEC_Raw)

# Remove duplicate rows (any row with matching ChildStudyID and BRIEF_Completion
# values)
current_rows <- l2t_dl$BRIEF
current_empties <- filter(current_rows, is.na(BRIEF_Completion))

# Check for raw-data rows not in the output
anti_join(current_rows, with_brief) %>% inner_join(cds) %>% glimpse

to_add <- with_brief %>%
  anti_join(current_rows, by = c("ChildStudyID", "BRIEF_Completion")) %>%
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

# Check that composite scores were added correctly
brief <- collect("BRIEF" %from% l2t) %>% left_join(cds)

filter(brief, Inhibit_Raw + EC_Raw != ISCI_Raw) %>%
  select(ShortResearchID, Inhibit_Raw, EC_Raw, ISCI_Raw)

filter(brief, Shift_Raw + EC_Raw != FI_Raw)

filter(brief, WM_Raw + PO_Raw != EMI_Raw)

filter(brief, Inhibit_Raw + Shift_Raw + EC_Raw + WM_Raw + PO_Raw != GEC_Raw) %>%
  select(ShortResearchID, Inhibit_Raw, Shift_Raw, EC_Raw, WM_Raw, PO_Raw, GEC_Raw)
