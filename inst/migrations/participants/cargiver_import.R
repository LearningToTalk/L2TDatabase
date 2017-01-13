
library(dplyr)
library(L2TDatabase)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf", "backend")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Get ResearchIDs
cds <- tbl(l2t, "Child") %>%
  left_join(tbl(l2t, "ChildStudy")) %>%
  select(ChildID, HouseholdID, ShortResearchID) %>%
  collect %>%
  distinct()

# Get the data-entry results for caregiver indo
cg <- l2t %>% tbl("Caregiver_Entry") %>% collect

# Check over data-entry
cg %>% distinct(Race) %>% arrange(Race)
cg %>% distinct(Relation) %>% arrange(Relation)
cg %>% distinct(Education) %>% arrange(Education) %>% as.data.frame
cg %>% distinct(Occupation) %>% arrange(Occupation) %>% as.data.frame


# Caregivers that match a ResearchID in the database
can_add_to_db <- cg %>%
  rename(ShortResearchID = ResearchID) %>%
  semi_join(cds)

# Caregiver data-entry rows that don't match a child in the database
no_db_match <- cg %>%
  rename(ShortResearchID = ResearchID) %>%
  anti_join(cds)


cg_rows_to_add <- can_add_to_db %>%
  inner_join(cds) %>%
  select(-ChildID, -CaregiverID, -CaregiverID_Timestamp, -ShortResearchID) %>%
  rename(Caregiver_Relation = Relation,
         Caregiver_Race = Race,
         Caregiver_Ethnicity = Ethnicity,
         Caregiver_Education = Education,
         Caregiver_OccupationRaw = OccupationRaw,
         Caregiver_Occupation = Occupation,
         Caregiver_OccupationCategory = OccupationCategory)

rows_to_add <- cg_rows_to_add %>%
  match_columns(tbl(l2t, "Caregiver"))

# append_rows_to_table(l2t, "Caregiver", rows_to_add)

# Update the data-entry table

# [I deleted the contents of the data-entry table through phpMyAdmin here...]

# Push the remaining data-entry rows back to database
no_db_match <- no_db_match %>% rename(ResearchID = ShortResearchID)
# append_rows_to_table(l2t, "Caregiver_Entry", no_db_match)

tbl(l2t, "Caregiver")
