# Add evt scores to the database
# Supports T1, T2, T3

library("L2TDatabase")
library("dplyr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo, chdir = TRUE)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get T1/T2/T3 scores for both sites. Function sourced via paths$GetSiteInfo
t1 <- get_study_info("TimePoint1")
t2 <- get_study_info("TimePoint2")
t3 <- get_study_info("TimePoint3")

maybe_starts_with <- function(...) {
  vars <- starts_with(...)
  if (all(vars < 0)) numeric() else vars
}

process_scores <- . %>%
  select(Study,
         ShortResearchID = Participant_ID,
         EVT_Form,
         EVT_Completion = maybe_starts_with("EVT_COMPLETION"),
         EVT_Raw = maybe_starts_with("EVT_raw"),
         EVT_Standard = maybe_starts_with("EVT_standard"),
         EVT_GSV) %>%
  mutate(EVT_Completion = format(EVT_Completion))

scores <- c(t1, t2, t3) %>%
  lapply(process_scores) %>%
  bind_rows

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the EVT scores
with_evt <- left_join(scores, cds)

# Kids in spreadsheets not in database. Should be empty rows (attrition)
scores %>% anti_join(cds) %>% as.data.frame

# Calculate chronological ages, default to NA if error encountered
chr_age <- failwith(NA, chrono_age)

with_evt <-  with_evt %>%
  filter(!is.na(EVT_Completion)) %>%
  mutate(EVT_Age = unlist(Map(chr_age, EVT_Completion, Birthdate)))

# Find completely new records that need to be added
latest_data <- match_columns(with_evt, l2t_dl$EVT) %>%
  arrange(ChildStudyID)

to_add <- latest_data %>%
  anti_join(l2t_dl$EVT, by = c("ChildStudyID"))
to_add

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
stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
render_diff(daff)

# save them
render_diff(daff, file = sprintf("inst/diffs/%s_evt_diffs.html", stamp))
daff::write_diff(daff, file = sprintf("inst/diffs/%s_evt_.csv", stamp))

# Or see them itemized in a long data-frame
create_diff_table(latest_data, remote_data, "EVTID")

overwrite_rows_in_table(l2t, "EVT", rows = latest_data, preview = TRUE)
overwrite_rows_in_table(l2t, "EVT", rows = latest_data, preview = FALSE)

