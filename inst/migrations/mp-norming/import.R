library(L2TDatabase)
library(dplyr)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, db_name = "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

scheme <- "./inst/migrations/mp-norming/mp-norming.xlsx" %>%
  readxl::read_excel(sheet = 3) %>%
  rename_all(stringr::str_replace, "MPNormingClosed_", "") %>%
  mutate(Side = ifelse(Side == "R", "right", "left"))

df_scheme_remote <- tbl(l2t, "MPNormingClosed_Design") %>%
  collect()

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = scheme,
  ref_data = df_scheme_remote,
  required_cols = "ItemNumber") %>%
  readr::type_convert() %>%
  arrange(ItemSet, ItemNumber)
df_to_add

# append_rows_to_table(l2t, "MPNormingClosed_Design", df_to_add)

df_scheme_remote <- tbl(l2t, "MPNormingClosed_Design") %>%
  collect() %>%
  select(-MPNormingClosed_Design_Timestamp)

mp_words <- c("guck", "shoup", "gake", "dirl", "wice", "sues")

oa1 <- "./inst/migrations/mp-norming/mp-norming.xlsx" %>%
  readxl::read_excel(sheet = 1) %>%
  rename(Completion = MPNormingClosed_Completion) %>%
  tidyr::gather(Item, Correct, -ResearchID, -Completion) %>%
  mutate(
    ItemNumber = Item %>% stringr::str_extract("\\d+") %>% as.numeric(),
    Item = Item %>% stringr::str_replace("_item.+", ""),
    Type = ifelse(Item %in% mp_words, "mispronunciation", "nonword"),
    ItemSet = "A")

oa2 <- "./inst/migrations/mp-norming/mp-norming.xlsx" %>%
  readxl::read_excel(sheet = 2) %>%
  rename(Completion = MPNormingClosed_Completion) %>%
  tidyr::gather(Item, Correct, -ResearchID, -Completion) %>%
  mutate(
    ItemNumber = Item %>% stringr::str_extract("\\d+") %>% as.numeric(),
    Item = Item %>% stringr::str_replace("_item.+", ""),
    Type = ifelse(Item %in% mp_words, "mispronunciation", "nonword"),
    ItemSet = "B")

# Check the metadata
bind_rows(oa1, oa2) %>%
  left_join(df_scheme_remote) %>%
  distinct(Item, ItemNumber, Type, ItemSet, Image1, Image2)

bind_rows(oa1, oa2) %>%
  left_join(df_scheme_remote) %>%
  distinct(Item, ItemNumber, Type, ItemSet, Image1, Image2) %>%
  summary()

df_norming <- bind_rows(oa1, oa2) %>%
  left_join(scheme) %>%
  mutate(Study = "TimePoint3") %>%
  left_join(df_cds %>% rename(ResearchID = ShortResearchID)) %>%
  mutate(
    MPNormingClosed_Age = chrono_age(MPNormingClosed_Completion, Birthdate))

# Create table of test administrations
df_admin <- bind_rows(oa1, oa2) %>%
  select(ResearchID, Completion) %>%
  distinct() %>%
  mutate(Study = "TimePoint3") %>%
  left_join(df_cds %>% rename(ResearchID = ShortResearchID)) %>%
  mutate(
    Age = chrono_age(Completion, Birthdate)) %>%
  select(
    MPNormingClosed_Admin_Completion = Completion,
    MPNormingClosed_Admin_Age = Age,
    ChildStudyID)

# Find completely new records that need to be added
df_admin_remote <- tbl(l2t, "MPNormingClosed_Admin") %>%
  collect() %>%
  select(-MPNormingClosed_Admin_Timestamp)

df_to_add <- find_new_rows_in_table(
  data = df_admin,
  ref_data = df_admin_remote,
  required_cols = "ChildStudyID") %>%
  readr::type_convert() %>%
  arrange(ChildStudyID)

# append_rows_to_table(l2t, "MPNormingClosed_Admin", df_to_add)

# Download again to get Admin IDs
df_admin_remote <- tbl(l2t, "MPNormingClosed_Admin") %>%
  collect() %>%
  select(-MPNormingClosed_Admin_Timestamp)

df_responses <- bind_rows(oa1, oa2) %>%
  mutate(Study = "TimePoint3") %>%
  left_join(df_cds %>% rename(ResearchID = ShortResearchID)) %>%
  left_join(df_admin_remote) %>%
  left_join(df_scheme_remote) %>%
  select(
    MPNormingClosed_AdminID,
    MPNormingClosed_DesignID,
    MPNormingClosed_Responses_Correct = Correct)

# Find completely new records that need to be added
df_responses_remote <- tbl(l2t, "MPNormingClosed_Responses") %>%
  collect() %>%
  select(-MPNormingClosed_Responses_Timestamp)

df_to_add <- find_new_rows_in_table(
  data = df_responses,
  ref_data = df_responses_remote,
  required_cols = c("MPNormingClosed_AdminID", "MPNormingClosed_DesignID")) %>%
  arrange(MPNormingClosed_AdminID, MPNormingClosed_DesignID)

# append_rows_to_table(l2t, "MPNormingClosed_Responses", df_to_add)


# Recreate the original tables
df_responses_remote <- tbl(l2t, "MPNormingClosed_Responses") %>%
  collect() %>%
  select(-MPNormingClosed_Responses_Timestamp)

oa_remote <- df_responses_remote %>%
  left_join(df_admin_remote) %>%
  left_join(df_scheme_remote) %>%
  left_join(df_cds) %>%
  select(
    ResearchID = ShortResearchID,
    Completion = MPNormingClosed_Admin_Completion,
    Item,
    Correction = MPNormingClosed_Responses_Correct,
    ItemNumber,
    Type,
    ItemSet) %>%
  arrange(ResearchID, ItemNumber)

oa_local <- bind_rows(oa1, oa2) %>%
  arrange(ResearchID, ItemNumber)

all(oa_remote == oa_local)

