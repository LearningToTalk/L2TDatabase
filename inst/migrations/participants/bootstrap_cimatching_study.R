# Create Child/ChildStudy/Household/Caregiver entries for participants from the
# CochlearMatching study

# The ChildStudy table requires a ChildID value. The Child table requires a
# HouseholdID value. So we are going to
# - create HouseholdIDs (new rows in Household table),
# - add those generated IDs to the data-entry table,
# - create new Child IDs (new rows in Child table),
# - add those generated IDs to the data-entry-plus-HouseholdID table
# - create new ChildStudyIDs

library(dplyr)
library(L2TDatabase)

# Some data entry I did locally...
spreadsheet <- "C:/Users/mahr/Documents/new_participants_data_entry_cimatching.xls"

parents_to_add <- spreadsheet %>%
  readxl::read_excel(sheet = 3)

children_to_add <- spreadsheet %>%
  readxl::read_excel(sheet = 4) %>%
  readr::type_convert()

# Get database tables
l2t <- l2t_connect("./inst/l2t_db.cnf", "backend")

tbl_child <- tbl(l2t, "Child")
tbl_childstudy <- tbl(l2t, "ChildStudy")
tbl_study <- tbl(l2t, "Study")

tbl_cds <- tbl_child %>%
  left_join(tbl_childstudy) %>%
  left_join(tbl_study) %>%
  select(ChildID, Study, ShortResearchID) %>%
  collect()

# These are brand new children. THey don't have any siblings in other studies,
# and their four-character IDs uniquely identify them. So we can generate new
# Household IDs for each child by new rows to the Household table
households_to_add <- children_to_add %>%
  select(Household_Note = ShortResearchID) %>%
  match_columns(tbl(l2t, "Household"))
# append_rows_to_table(l2t, "Household", households_to_add)

# Get the newly minted household ids
household_ids <- tbl(l2t, "Household") %>%
  collect() %>%
  inner_join(households_to_add) %>%
  rename(ShortResearchID = Household_Note)

# Add the Household IDs to the Child table and then add new rows to Child table
child_rows_to_add <- children_to_add %>%
  inner_join(household_ids) %>%
  match_columns(tbl_child)
# append_rows_to_table(l2t, "Child", child_rows_to_add)

# Get the newly minted ChildIDs.
new_rows <- tbl(l2t, "Child") %>%
  collect() %>%
  readr::type_convert() %>%
  inner_join(child_rows_to_add) %>%
  # Combine with study name and study ids
  inner_join(children_to_add) %>%
  inner_join(collect(tbl(l2t, "Study")))

nrow(new_rows) == nrow(children_to_add)

child_study_rows_to_add <- new_rows %>%
  match_columns(tbl_childstudy)

# append_rows_to_table(l2t, "ChildStudy", child_study_rows_to_add)



# Add the parents by combining the child's HouseholdID to the parent's
# data-entry table.

# Get household IDs
household_ids <- new_rows %>%
  select(HouseholdID, ResearchID = ShortResearchID)

# Match the names of the database table
parent_rows_to_add <- parents_to_add %>%
  inner_join(household_ids) %>%
  rename(Caregiver_Relation = Relation,
         Caregiver_Race = Race,
         Caregiver_Ethnicity = Ethnicity,
         Caregiver_Education = Education,
         Caregiver_OccupationRaw = OccupationRaw,
         Caregiver_Occupation = Occupation,
         Caregiver_OccupationCategory = OccupationCategory) %>%
  match_columns(tbl(l2t, "Caregiver")) %>%
  select(HouseholdID, everything())
parent_rows_to_add

append_rows_to_table(l2t, "Caregiver", parent_rows_to_add)
