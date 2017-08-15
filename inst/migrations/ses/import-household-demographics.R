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

# Get results of earlier SES data entry
entry1 <- tbl(backend, "SES_Entry") %>%
  collect() %>%
  mutate(Source = "old_entry")


# Race/ethnicity checks
race_ethn <- cds %>%
  select(Source, ResearchID,
         Child_Race = ChildRace, Child_Ethnicity = ChildEthnicity)

race_ethn2 <- entry1 %>%
  select(Source, ResearchID, Child_Race, Child_Ethnicity)

# Check old entry against current
bind_rows(race_ethn, race_ethn2) %>%
  mutate(Child_Race = Child_Race %>%
           stringr::str_replace("Black/African", "Black or African")) %>%
  tidyr::gather(Key, Value, -ResearchID, -Source) %>%
  tidyr::spread(Source, Value) %>%
  filter(current %!==% old_entry, !is.na(old_entry)) %>%
  print(n = Inf)

race_ethn %>% distinct(Child_Race) %>% arrange(Child_Race)
race_ethn %>% distinct(Child_Ethnicity) %>% arrange(Child_Ethnicity)



# Tidy the results of the last data entry
old_ses_entry <- entry1 %>%
  left_join(cds %>% select(-Source)) %>%
  select(Source, HouseholdID, IDsInHousehold, ResearchID,
         Household_Under18:Household_MaritalStatus) %>%
  mutate(IDsInHousehold =
           stringr::str_replace(IDsInHousehold, " = ", " / ")) %>%
  tidyr::gather(Key, Value, -HouseholdID, -IDsInHousehold, -Source, -ResearchID)

ids_by_household <- cds %>% select(ResearchID, HouseholdID)

fix_values <- . %>%
  stringr::str_replace("0 [-] [$]", "0 to $") %>%
  stringr::str_replace("Below .20,000", "Less than $20,000") %>%
  stringr::str_replace("Single, never married", "Single (never married)") %>%
  stringr::str_replace(".100,000 to .200,000", "$101,000 to $200,000") %>%
  stringr::str_replace("Not (provided|listed)", "Prefer not to answer")


umd <- xl_counts %>%
  select(-DataEntryNotes) %>%
  left_join(ids_by_household) %>%
  mutate(
    Household_FamilyIncome = fix_values(Household_FamilyIncome),
    Household_MaritalStatus = fix_values(Household_MaritalStatus)) %>%
  tidyr::gather(Key, Value, -HouseholdID, -IDsInHousehold, -Source, -ResearchID)



old_ses_entry %>% pull(Key) %>% unique()
umd %>% pull(Key) %>% unique()

# See the unique values used in each source
bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  distinct(Source, Value) %>%
  arrange(Value) %>%
  print(n = Inf)

# See which responses were coded as not answered
bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  filter(Value %in% c("Not provided", "Not listed", "Prefer not to answer")) %>%
  arrange(Value) %>%
  print(n = Inf)

# Look for mismatches between current data entry and previous one
bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  tidyr::spread(Source, Value) %>%
  filter(old_entry != UMD) %>%
  print(n = Inf)

# Look for cases where data was entered in the last data entry round but not in
# the most recent round
bind_rows(old_ses_entry, umd) %>%
  mutate(Value = fix_values(Value)) %>%
  tidyr::spread(Source, Value) %>%
  # filter(old_entry %!==% UMD) %>%
  filter(!is.na(old_entry), is.na(old_entry) != is.na(UMD)) %>%
  select(-HouseholdID) %>%
  print(n = Inf)


# Push the data into the database
data_to_add <- umd %>%
  tidyr::spread(Key, Value) %>%
  select(HouseholdID,
         Household_NumAdults = Household_Adults,
         Household_NumAdultsContributeIncome = Household_AdultsContributeIncome,
         Household_FamilyIncome = Household_FamilyIncome,
         Household_MaritalStatus = Household_MaritalStatus,
         Household_NumChildrenUnder18 = Household_Under18) %>%
  distinct() %>%
  readr::type_convert()

current_rows <- tbl(backend, "Household") %>% collect()

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = data_to_add,
  ref_data = current_rows,
  required_cols = "HouseholdID")
df_to_add

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(backend, "Household", df_to_add)



## Find records that need to be updated

# Redownload the table
df_remote <- collect("Household" %from% backend)

# Attach the database keys to latest data
df_remote_indices <- df_remote %>%
  select(HouseholdID)

df_local <- data_to_add %>%
  inner_join(df_remote_indices) %>%
  arrange(HouseholdID)

# Keep just the columns in the latest data
df_remote <- match_columns(df_remote, df_local) %>%
  filter(HouseholdID %in% df_local$HouseholdID) %>%
  arrange(HouseholdID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote, df_local, unchanged_context = 0)
stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote, "HouseholdID")

overwrite_rows_in_table(backend, "Household", rows = df_local, preview = TRUE)
overwrite_rows_in_table(backend, "Household", rows = df_local, preview = FALSE)

# Check one last time
df_remote <- collect("Household" %from% backend)
anti_join(df_remote, df_local, by = "HouseholdID")
anti_join(df_local, df_remote)
