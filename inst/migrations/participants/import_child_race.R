# Initialize the ChildRace and ChildEthnicity fields for participants from the
# longitudinal study.

library("L2TDatabase")
library("dplyr")

cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

t1_ids <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  filter(Study == "TimePoint1") %>%
  select(ChildID, ResearchID = ShortResearchID)

# Get race and ethnicity from the hand-entered data
with_race_ethnicity <- t1_ids %>%
  left_join(l2t_dl$SES_Entry) %>%
  select(ChildID, ResearchID,
         ChildEthnicity = Child_Ethnicity,
         ChildRace = Child_Race)

overwrite_rows_in_table(l2t, "Child", with_race_ethnicity)
overwrite_rows_in_table(l2t, "Child", with_race_ethnicity, preview = FALSE)


# # Use these to update the CI participants, once their survey data has been
# # parsed
# c1_ids <- l2t_dl$ChildStudy %>%
#   left_join(l2t_dl$Study) %>%
#   filter(Study == "CochlearV1") %>%
#   select(ChildID, ResearchID = ShortResearchID)
#
# with_race_ethnicity2 <- c1_ids %>%
#   left_join(l2t_dl$SES_Entry) %>%
#   select(ChildID, ResearchID,
#          ChildEthnicity = Child_Ethnicity,
#          ChildRace = Child_Race)
