# Bootstrap the table of family IDs

library(stringr)
library(purrr)
library(dplyr)

# I wrote out all the siblings in our studies. One line per set of related
# children. https://github.com/LearningToTalk/L2TDatabase/issues/44

long_twins <- "
  019L / 020L
  041L / 042L
  059L / 060L
  093L / 094L
  097L / 098L / 099L
  100L / 101L
  118L / 119L
  121L / 122L
  671L / 684L
  680L / 681L
  685L / 686L"

cross_study <- "
  011L / 126L
  017L / 438D
  024L / 428D
  076L / 411D
  095L / 096L / 441D
  083L / 446D
  110L / 111L / 422D
  112L / 418D
  114L / 442D
  120L / 407D
  129L / 130L / 300E
  132L / 424D
  305E / 456D
  443D / 500M
  553M / 554M
  509M / 510M
  625L / 683L"

# Used to have
#   302E / 452D
#   091L / 420D
# the dialect children did not contribute any data...

# Make a vector of sibling sets
sib_set <- c(long_twins, cross_study) %>%
  str_split("\n") %>%
  unlist %>%
  # Remove whitespace and empty lines
  str_trim() %>%
  str_subset("\\w")

# Make a data-frame for each sibling set, use the original sibling set string
# ("child1 / child2") as a unique identifier
df_siblings <- sib_set %>%
  map(str_split, " / ") %>%
  flatten %>%
  # Set names so that they can be attached as a column during map_df
  set_names(sib_set) %>%
  map_df(tibble::enframe, "Row", "ShortResearchID", .id = "SibSet") %>%
  select(-Row)

df_siblings



library(L2TDatabase)

l2t <- l2t_connect("./inst/l2t_db.cnf")

tbl_child <- tbl(l2t, "Child")
tbl_childstudy <- tbl(l2t, "ChildStudy")
tbl_study <- tbl(l2t, "Study")

tbl_cds <- tbl_child %>%
  left_join(tbl_childstudy) %>%
  left_join(tbl_study) %>%
  select(ChildID, Study, ShortResearchID) %>% collect()

# Children not in database yet
not_in_db_yet <- df_siblings %>% anti_join(tbl_cds)

# Sibsets that contain a child not in the database
sib_sets_to_set_aside <- not_in_db_yet %>%
  select(SibSet) %>%
  distinct()

# Set aside children in database who have a sibling not yet in database
kids_to_set_aside <- sib_sets_to_set_aside %>%
  inner_join(df_siblings) %>%
  inner_join(tbl_cds) %>%
  select(ChildID)

can_be_added_to_db <- df_siblings %>%
  anti_join(sib_sets_to_set_aside)

# Attach child ids to the children with known siblings
child_ids_of_siblings <- can_be_added_to_db %>%
  inner_join(tbl_cds) %>%
  distinct(SibSet, ChildID)

# Children who are not in the set-aside or sibling sets
singletons <- tbl_cds %>%
  anti_join(kids_to_set_aside) %>%
  anti_join(child_ids_of_siblings) %>%
  group_by(ChildID) %>%
  # Collapse multiple ResearchID for a single child into one string
  summarise(SibSet = paste0(unique(ShortResearchID), collapse = " = "))

households <- child_ids_of_siblings %>% bind_rows(singletons)

households
tbl(l2t, "Child") %>% collect

households_to_add <- households %>%
  arrange(SibSet, ChildID) %>%
  rename(Household_Note = SibSet)

rows_to_add <- households_to_add %>%
  select(-ChildID) %>%
  distinct %>%
  arrange(Household_Note)

# append_rows_to_table(l2t, "Household", rows_to_add)



