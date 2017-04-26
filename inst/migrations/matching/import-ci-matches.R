# Import the hand-matched hearing versus ci participants into database

library(dplyr)
library(L2TDatabase)
cnf_file <- "./inst/l2t_db.cnf"
l2t_backend <- l2t_connect(cnf_file, "backend")

push <- FALSE

# Load the hand-matches
df_matches <- readr::read_csv("./inst/migrations/matching/handmatched.csv") %>%
  rename(CIMatchingPairID = MatchPairID, CIMatching_Group = MatchingSubset)
df_matches

# Get database's child-study identifiers
tbl_childstudy <- tbl(l2t_backend, "ChildStudy") %>%
  left_join(tbl(l2t_backend, "Study")) %>%
  select(Study, ResearchID = ShortResearchID, ChildID, ChildStudyID) %>%
  collect()

# Attach database ids to matches
matches_to_add <- df_matches %>%
  left_join(tbl_childstudy) %>%
  select(ChildStudyID, ChildID, CIMatching_Group, CIMatchingPairID)

matches_to_add %>% filter(is.na(ChildStudyID))
matches_to_add %>% filter(is.na(ChildID))

# Number of kids in each group
matches_to_add %>%
  count(CIMatching_Group)

# Only two children per each pair
matches_to_add %>%
  count(CIMatchingPairID) %>%
  filter(n != 2)

# Every pairs had a CI and an NH participant
matches_to_add %>%
  count(CIMatchingPairID, CIMatching_Group) %>%
  filter(n != 1)

# No duplicated ChildStudyIDs
stopifnot(n_distinct(matches_to_add$ChildStudyID) == nrow(matches_to_add))

# Get the remote table
matching_tbl <- collect(tbl(l2t_backend, "CIMatching"))

# Keep local columns that are in the remote table
matches_to_add <- matches_to_add %>%
  match_columns(matching_tbl) %>%
  arrange(CIMatching_Group, CIMatchingPairID)

# Upload
if (push) {
  append_rows_to_table(
    src = l2t_backend,
    tbl_name = "CIMatching",
    rows = matches_to_add)
}

# Check that the data is the same in both locations
remote_matching_tbl <- collect(tbl(l2t_backend, "CIMatching"))

anti_join(remote_matching_tbl, matches_to_add)
anti_join(matches_to_add, remote_matching_tbl)
