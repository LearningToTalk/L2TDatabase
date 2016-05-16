# One time script to add UW CI children to database

library("L2TDatabase")
library("dplyr")
library("readxl")

# Connect to db
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)

kids_to_add <- read_excel("C:/Users/mahr/Desktop/manual_ci_import.xls") %>%
  # 306E was manually added bc she also partipated in longitudinal study
  filter(ShortResearchID != "306E") %>%
  mutate(Child_Note = paste0("UW CI V1 ", ShortResearchID))

# Fetch remote copy
child <- l2t %>% tbl("Child") %>% collect

# Format data to match remote version
new_children <- kids_to_add %>% match_columns(child)

# Double check for matches beforehand
inner_join(child, new_children)

# # Add new children to database
# append_rows_to_table(l2t, "Child", rows = new_children)

# Attach newly assigned Child IDs to research ids
child <- l2t %>% tbl("Child") %>% collect

with_child_ids <- kids_to_add %>%
  left_join(child) %>%
  select(ChildID, ShortResearchID, V1_FullResearchID, V2_FullResearchID)

study_ids <- tbl(l2t, "Study") %>% select(StudyID, Study) %>% collect

ci_v1 <- with_child_ids %>%
  select(ChildID, ShortResearchID, FullResearchID = V1_FullResearchID) %>%
  mutate(Study = "CochlearV1") %>%
  left_join(study_ids)
ci_v1

ci_v2 <- with_child_ids %>%
  select(ChildID, ShortResearchID, FullResearchID = V2_FullResearchID) %>%
  mutate(Study = "CochlearV2") %>%
  filter(!is.na(FullResearchID)) %>%
  left_join(study_ids)
ci_v2


child_study <- tbl(l2t, "ChildStudy") %>% collect

ci_v1 <- match_columns(ci_v1, child_study)
ci_v2 <- match_columns(ci_v2, child_study)

ci_v1 %>% inner_join(child_study)
ci_v2 %>% inner_join(child_study)

# append_rows_to_table(l2t, "ChildStudy", rows = ci_v1)
# append_rows_to_table(l2t, "ChildStudy", rows = ci_v2)


