# Add KBIT scores to the database

library("L2TDatabase")
library("dplyr")

# Load external dependencies
source("inst/paths.R")
source(paths$GetSiteInfo, chdir = TRUE)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, db_name = "backend")
# l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get info for both sites. Function sourced via paths$GetSiteInfo
t1 <- get_study_info("TimePoint1")
t2 <- get_study_info("TimePoint2")
t3 <- get_study_info("TimePoint3")
ci1 <- get_study_info("CochlearV1")
ci2 <- get_study_info("CochlearV2")
cim <- get_study_info("CochlearMatching")
lt <- get_study_info("LateTalker")
medu <- get_study_info("MaternalEd")
dialect <- get_study_info("DialectSwitch")

process_scores <- . %>%
  select(Study,
         ShortResearchID = Participant_ID,
         KBIT_Completion = maybe_starts_with("KBIT_Date"),
         maybe_starts_with("KBIT_Nonverbal_Raw"),
         maybe_starts_with("KBIT_Nonverbal_Standard"))


df_scores <- c(t1, t2, t3, ci1, ci2, cim, lt, medu, dialect) %>%
  lapply(process_scores) %>%
  bind_rows() %>%
  mutate(KBIT_Completion = format(KBIT_Completion)) %>%
  filter(!is.na(KBIT_Completion), !is.na(KBIT_Nonverbal_Raw))

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

# Kids in spreadsheets not in database
df_scores %>%
  anti_join(df_cds) %>%
  arrange(Study, ShortResearchID) %>%
  print(n = Inf)

# Attach the database identifiers to the KBIT scores
df_with_kbit <- left_join(df_scores, df_cds)

df_can_be_added <-  df_with_kbit %>%
  filter(!is.na(KBIT_Completion)) %>%
  mutate(KBIT_Age = chrono_age(KBIT_Completion, Birthdate)) %>%
  select(-Study, -ShortResearchID, -Birthdate)


# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = collect(tbl(l2t, "KBIT")),
  required_cols = "ChildStudyID")

df_to_add %>%
  left_join(df_with_kbit) %>%
  print(n = Inf)

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "KBIT", df_to_add)



## Find records that need to be updated

# Redownload the table
df_remote <- collect("KBIT" %from% l2t)

# Attach the database keys to latest data
df_remote_indices <- df_remote %>%
  select(ChildStudyID, KBITID)

df_local <- df_can_be_added %>%
  inner_join(df_remote_indices) %>%
  arrange(KBITID)

# Keep just the columns in the latest data
df_remote <- match_columns(df_remote, df_local) %>%
  filter(ChildStudyID %in% df_local$ChildStudyID) %>%
  arrange(KBITID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote, df_local, context = 0)
stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
render_diff(daff)

# save them
# render_diff(daff, file = sprintf("inst/diffs/%s_evt_diffs.html", stamp))
# daff::write_diff(daff, file = sprintf("inst/diffs/%s_evt_.csv", stamp))

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote, "KBITID")

overwrite_rows_in_table(l2t, "KBIT", rows = df_local, preview = TRUE)
overwrite_rows_in_table(l2t, "KBIT", rows = df_local, preview = FALSE)

# Check one last time
df_remote <- collect("KBIT" %from% l2t)
anti_join(df_remote, df_local, by = "KBITID")
anti_join(df_local, df_remote)
anti_join(df_can_be_added, df_remote)
anti_join(df_remote, df_can_be_added)
