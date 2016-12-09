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
  046L / 401D
  067L / 408D

  076L / 411D
  083L / 446D
  091L / 420D
  095L / 096L / 441D
  110L / 111L / 422D

  112L / 418D
  114L / 442D
  120L / 407D
  123L / 434D
  129L / 130L / 300E

  132L / 424D
  202T / 203T
  207T / 208T
  305E / 456D
  413D / 414D

  416D / 417D
  443D / 500M
  509M / 510M
  553M / 554M
  625L / 683L
"

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
not_in_db_yet

# Sibsets that contain a child not in the database
sib_sets_to_set_aside <- not_in_db_yet %>%
  select(SibSet) %>%
  distinct()
sib_sets_to_set_aside

# Set aside children in database who have a sibling not yet in database
kids_to_set_aside <- sib_sets_to_set_aside %>%
  inner_join(df_siblings) %>%
  inner_join(tbl_cds) %>%
  select(ChildID)
kids_to_set_aside

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

households <- child_ids_of_siblings %>%
  bind_rows(singletons)

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


# Add HouseholdIds back to ChildIDs
curr_households <- l2t %>% tbl("Household") %>% collect

child_household_pairs <- households_to_add %>%
  inner_join(curr_households) %>%
  select(ChildID, HouseholdID)

child_household_pairs %>% count(ChildID)
child_household_pairs %>% count(HouseholdID)
child_household_pairs %>% count(HouseholdID) %>% filter(1 < n)


# Now we have to modify rows in the Child table to have the new HouseholdIDs
tbl_child_remote <- tbl(l2t, "Child") %>% collect

tbl_child_local <- tbl(l2t, "Child") %>%
  collect %>%
  select(-HouseholdID) %>%
  inner_join(child_household_pairs)

overwrite_rows_in_table(l2t, "Child", rows = tbl_child_local, preview = TRUE)
# overwrite_rows_in_table(l2t, "Child", rows = tbl_child_local, preview = FALSE)


# See if we can reconstruct siblings
everyone <- tbl(l2t, "Child") %>%
  left_join(tbl(l2t, "ChildStudy")) %>%
  collect()

everyone %>%
  select(ShortResearchID, ChildID, HouseholdID) %>%
  # Flatten different ResearchIDs within children into a single string
  group_by(ChildID) %>%
  mutate(Alias = ShortResearchID %>% unique %>%
           sort %>% paste0(collapse = " = ")) %>%
  # Flatten the list of IDs into a single string
  group_by(HouseholdID) %>%
  summarise(nKids = n_distinct(ChildID),
            Kids = Alias %>% unique %>% sort %>% paste0(collapse = " / ")) %>%
  filter(1 < nKids) %>%
  as.data.frame

# Everyone has a HouseholdID
tbl(l2t, "Child") %>%
  collect %>%
  filter(is.na(HouseholdID))

