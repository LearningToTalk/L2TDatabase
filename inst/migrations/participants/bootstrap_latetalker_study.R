library(dplyr)
library(L2TDatabase)

# Some data entry I did locally...
spreadsheet <- "C:/Users/mahr/Documents/new_participants_data_entry.xls"

parents_to_add <- spreadsheet %>% readxl::read_excel(sheet = 3)
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
  select(ChildID, Study, ShortResearchID) %>% collect()

# Add the parents
parent_rows_to_add <- parents_to_add %>%
  match_columns(tbl(l2t, "Caregivers_Entry"))

# append_rows_to_table(l2t, "Caregivers_Entry", parent_rows_to_add)

# Add the new study names
new_studies <- data_frame(
  Study = c("MaternalEd", "LateTalker"),
  Study_Code = c("M", "T"))

# append_rows_to_table(l2t, "Study", new_studies)


# Add the new children
rows_to_add <- children_to_add %>%
  match_columns(tbl_child)
# append_rows_to_table(l2t, "Child", rows_to_add)

# Get the newly minted ChildIDs
new_rows <- tbl(l2t, "Child") %>%
  collect() %>%
  readr::type_convert() %>%
  inner_join(rows_to_add) %>%
  # Combine with study name and study ids
  inner_join(children_to_add) %>%
  inner_join(collect(tbl(l2t, "Study")))

nrow(new_rows) == nrow(children_to_add)

child_study_rows_to_add <- new_rows %>%
  match_columns(tbl_childstudy)

# append_rows_to_table(l2t, "ChildStudy", child_study_rows_to_add)
