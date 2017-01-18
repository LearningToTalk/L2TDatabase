# Add timepoint1 BRIEF scores to the database

library("L2TDatabase")
library("dplyr")
library("stringr")

# Load external dependencies
source("inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")


briefs <- readr::read_csv(paths$briefs) %>%
  rename(ShortResearchID = Participant_ID)

# Check how names line up
names(briefs)[names(briefs) %in% colnames("BRIEF" %from% l2t)]
names(briefs)[!names(briefs) %in% colnames("BRIEF" %from% l2t)]

# UMN kept all inconsistency scores. UW only kept high inconsistency scores, so
# move inconsistency scores to notes column, lest we think a bunch of data is
# missing.

# Check values in each column. Want to know what strings are in the nominal
# score columns.
lapply(briefs, unique)
lapply(briefs, function(xs) str_subset(xs, "[A-z]"))

# Combine child-study-childstudy tbls
cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(Study, ShortResearchID, Birthdate, ChildStudyID) %>%
  collect()
cds

# Attach the database identifiers to the BRIEF scores
briefs <- briefs %>%
  left_join(cds) %>%
  mutate(BRIEF_Age = chrono_age(Birthdate, BRIEF_Completion))

# Check the raw data first
briefs %>% filter(is.na(BRIEF_Completion))
briefs %>% filter(Inhibit_Raw + EC_Raw != ISCI_Raw)
briefs %>% filter(Shift_Raw + EC_Raw != FI_Raw)
briefs %>% filter(WM_Raw + PO_Raw != EMI_Raw)
briefs %>% filter(Inhibit_Raw + Shift_Raw + EC_Raw + WM_Raw + PO_Raw != GEC_Raw) %>%
  select(ShortResearchID, Inhibit_Raw, Shift_Raw, EC_Raw, WM_Raw, PO_Raw, GEC_Raw)
range(briefs$BRIEF_Age)

# Remove duplicate rows (any row with matching ChildStudyID and BRIEF_Completion
# values)
current_rows <- tbl(l2t, "BRIEF") %>% collect()

briefs$BRIEF_Completion <- format(briefs$BRIEF_Completion)

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = briefs,
  ref_data = current_rows,
  required_cols = "ChildStudyID")
df_to_add

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "BRIEF", df_to_add)

