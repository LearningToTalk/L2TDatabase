library(dplyr)
library(L2TDatabase)

# Read in the data entered into the spreadsheet
xl_counts <- "./inst/migrations/ses/household-data-entry.xlsx" %>%
  readxl::read_xlsx() %>%
  rename(
    Household_Under18 = NumChildrenUnder18InHousehold,
    Household_Adults = NumAdultsInHousehold,
    Household_AdultsContributeIncome = NumAdultsContributingIncomeToHousehold,
    Household_FamilyIncome = HouseholdFamilyIncome,
    Household_MaritalStatus = HouseholdMaritalStatus) %>%
  mutate(Source = "UMD") %>%
  readr::type_convert()

# Get the HouseholdIDs and ResearchIDs from the database
backend <- l2t_connect(cnf_file = "./inst/l2t_db.cnf", db_name = "backend")

q_households <- tbl(backend, "Household") %>%
  select(HouseholdID, IDsInHousehold = Household_Note)

cds <- tbl(backend, "ChildStudy") %>%
  rename(ResearchID = ShortResearchID) %>%
  select(ChildID, ResearchID) %>%
  distinct() %>%
  left_join("Child" %from% backend) %>%
  select(ResearchID, ChildID, HouseholdID, ChildRace, ChildEthnicity) %>%
  left_join(q_households) %>%
  collect() %>%
  mutate(Source = "current")

# Get previous attempt at data entry
entry1 <- tbl(backend, "SES_Entry") %>%
  collect() %>%
  mutate(Source = "old_entry")


# Race/ethnicity checks
race_ethn <- cds %>%
  select(Source, ResearchID,
         Child_Race = ChildRace, Child_Ethnicity = ChildEthnicity)

race_ethn2 <- entry1 %>%
  select(Source, ResearchID, Child_Race, Child_Ethnicity)

# Check current against old entry
bind_rows(race_ethn, race_ethn2) %>%
  tidyr::gather(Key, Value, -ResearchID, -Source) %>%
  tidyr::spread(Source, Value) %>%
  filter(current != old_entry)

# Check old entry against current
bind_rows(race_ethn, race_ethn2) %>%
  tidyr::gather(Key, Value, -ResearchID, -Source) %>%
  tidyr::spread(Source, Value) %>%
  filter(current %!==% old_entry, !is.na(old_entry)) %>%
  print(n = Inf)


# Count checks
old_ses_entry <- entry1 %>%
  left_join(cds %>% select(-Source)) %>%
  select(Source, HouseholdID, IDsInHousehold, ResearchID,
         Household_Under18:Household_MaritalStatus) %>%
  tidyr::gather(Key, Value, -HouseholdID, -IDsInHousehold, -Source, -ResearchID)

ids_by_household <- cds %>% select(ResearchID, HouseholdID)

umd <- xl_counts %>%
  select(-DataEntryNotes) %>%
  left_join(ids_by_household) %>%
  tidyr::gather(Key, Value, -HouseholdID, -IDsInHousehold, -Source, -ResearchID)

old_ses_entry %>% pull(Key) %>% unique()
umd %>% pull(Key) %>% unique()

fix_values <- . %>%
  stringr::str_replace("0 [-] [$]", "0 to $") %>%
  stringr::str_replace("Below .20,000", "Less than $20,000") %>%
  stringr::str_replace("Single, never married", "Single (never married)") %>%
  stringr::str_replace(".100,000 to .200,000", "$101,000 to $200,000")

# See the unique values used in each source
bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  distinct(Source, Value) %>%
  arrange(Value) %>%
  print(n = Inf)

bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  filter(Value %in% c("Not provided", "Not listed", "Prefer not to answer")) %>%
  arrange(Value) %>%
  print(n = Inf)


bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  tidyr::spread(Source, Value) %>%
  filter(old_entry != UMD) %>%
  print(n = Inf)
