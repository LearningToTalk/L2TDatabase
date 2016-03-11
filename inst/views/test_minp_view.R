# Compare results of the MinPair View with the results obtained by using dplyr.
# This script is to make sure Tristan wrote the SQL query correctly.

library("L2TDatabase")
library("dplyr")

minp <- tbl(l2t, "MinPair_Admin")
minp_items <- tbl(l2t, "MinPair_Responses")
childstudy <- tbl(l2t, "ChildStudy")
study <- tbl(l2t, "Study")

prop_correct <- minp %>%
  left_join(minp_items, by = "MinPairID") %>%
  filter(Running == "Test") %>%
  group_by(ChildStudyID, MinPair_Dialect, MinPair_Completion,
           MinPair_EprimeFile, MinPairID) %>%
  summarise(PropCorrect = round(mean(Correct), 4)) %>%
  ungroup

prop_correct_final <- prop_correct %>%
  left_join(childstudy, by = "ChildStudyID") %>%
  left_join(study, by = "StudyID") %>%
  select(Study, ResearchID = ShortResearchID, MinPair_EprimeFile,
         MinPair_Completion, MinPair_Dialect, PropCorrect)

xs <- prop_correct_final %>% collect
ys <- tbl(l2t, "q_MinPair_Aggregate") %>% collect

xs$PropCorrect == ys$MinPair_ProportionCorrect

