library("L2TDatabase")
library("dplyr")

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
  readxl::read_excel(sheet = 3)

oa1 <- "./inst/migrations/mp-norming/mp-norming.xlsx" %>%
  readxl::read_excel(sheet = 1) %>%
  tidyr::gather(Item, Correct, -ResearchID, -MPNormingClosed_Completion) %>%
  mutate(
    ItemNumber = Item %>% stringr::str_extract("\\d+") %>% as.numeric(),
    Item = Item %>% stringr::str_replace("_item.+", ""),
    Type = ifelse(
      Item %in% c("guck", "shoup", "gake", "dirl", "wice", "sues"),
      "mispronunciation", "nonword"),
    ItemSet = "A") %>%
  rename(
    MPNormingClosed_ItemNumber = ItemNumber,
    MPNormingClosed_Item = Item,
    MPNormingClosed_Correct = Correct,
    MPNormingClosed_Type = Type,
    MPNormingClosed_ItemSet = ItemSet)

oa2 <- "./inst/migrations/mp-norming/mp-norming.xlsx" %>%
  readxl::read_excel(sheet = 2) %>%
  tidyr::gather(Item, Correct, -ResearchID, -MPNormingClosed_Completion) %>%
  mutate(
    ItemNumber = Item %>% stringr::str_extract("\\d+") %>% as.numeric(),
    Item = Item %>% stringr::str_replace("_item.+", ""),
    Type = ifelse(
      Item %in% c("guck", "shoup", "gake", "dirl", "wice", "sues"),
      "mispronunciation", "nonword"),
    ItemSet = "B") %>%
  rename(
    MPNormingClosed_ItemNumber = ItemNumber,
    MPNormingClosed_Item = Item,
    MPNormingClosed_Correct = Correct,
    MPNormingClosed_Type = Type,
    MPNormingClosed_ItemSet = ItemSet)

# Check the metadata
bind_rows(oa1, oa2) %>%
  left_join(scheme) %>%
  distinct(
    MPNormingClosed_Item,
    MPNormingClosed_ItemNumber,
    MPNormingClosed_Type,
    MPNormingClosed_ItemSet,
    MPNormingClosed_Image1,
    MPNormingClosed_Image2)

bind_rows(oa1, oa2) %>%
  left_join(scheme) %>%
  distinct(
    MPNormingClosed_Item,
    MPNormingClosed_ItemNumber,
    MPNormingClosed_Type,
    MPNormingClosed_ItemSet,
    MPNormingClosed_Image1,
    MPNormingClosed_Image2) %>%
  summary()

df_norming <- bind_rows(oa1, oa2) %>%
  left_join(scheme) %>%
  mutate(Study = "TimePoint3") %>%
  left_join(df_cds %>% rename(ResearchID = ShortResearchID)) %>%
  mutate(MPNormingClosed_Age = chrono_age(MPNormingClosed_Completion, Birthdate))

df_can_be_added <-  df_norming %>%
  filter(!is.na(MPNormingClosed_Completion)) %>%
  select(-Study, -ResearchID, -Birthdate)

df_norming_remote <- tbl(l2t, "MPNormingClosed") %>%
  collect()

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = df_norming_remote,
  required_cols = "ChildStudyID") %>%
  readr::type_convert()

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "MPNormingClosed", df_to_add)



