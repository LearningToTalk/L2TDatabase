# Bootstrap database tables for children in the dialect studies

# Fill with full file-paths to local folders/files
dialect_rawdata_folder <- ""  # path to OtherRawData/DialectRawData/Dialect
dialect_p_info <- ""          # ...ParticipantDialect_DataSummary.xls
dialect_dirt_info <- ""       # ...UWCrossSectionalDialectDatesScores.xls

library(stringr)
library(dplyr)

# Data is organized by Child / Study / [files], so we can infer Child-Study
# mappings from file-paths.
dialect_files <- list.files(
  dialect_rawdata_folder,
  full.names = TRUE,
  recursive = TRUE)

# Get ResearchID and Dialect from file names
create_child_study_dataframe <- function(path) {
  study <- str_extract(path, "DialectDensity|DialectSwitch")
  short_id <- str_extract(path, "\\d\\d\\dD")
  long_id <- str_extract(path, "\\d{3}D\\d{2}\\w{2}\\d")
  dialect <- paste0(str_extract(long_id, "S|A"), "AE")
  data_frame(study, short_id, dialect, long_id)
}

ids <- dialect_files %>%
  str_subset("\\d{3}D\\d{2}") %>%
  purrr::map_df(create_child_study_dataframe) %>%
  distinct

# Kids who participated in both dialect-related studies separately
ids %>%
  distinct(short_id, study) %>%
  count(short_id) %>%
  filter(n > 1)

# Get DOBs from DIRT spreadsheet
dirt_info <- readxl::read_excel(dialect_dirt_info, sheet = 1) %>%
  select(short_id = ParticipantID, DOB)

# Get native dialect and sex from scoring spreadsheet
p_info <- readxl::read_excel(dialect_p_info, sheet = 1) %>%
  mutate(NativeDialect = ifelse(AAE_Native, "AAE", "SAE")) %>%
  select(short_id = Participant_ID, NativeDialect, Female = female)

# Make sure each is exhaustive
dirt_info %>% anti_join(p_info)
p_info %>% anti_join(dirt_info)

# Combine information to determine the long-form research IDs
study_ids <- ids %>%
  left_join(p_info) %>%
  filter(NativeDialect == dialect) %>%
  group_by(dialect, NativeDialect, Female, study, short_id) %>%
  # Use first long-form id alphabetically in case some differ in last digit
  summarise(long_id = sort(long_id)[1]) %>%
  ungroup() %>%
  left_join(dirt_info)

# These are the fields needed for Child table
child_ids <- study_ids %>%
  mutate(AAE = as.numeric(dialect == "AAE"),
         LateTalker = 0,
         CImplant = 0) %>%
  select(short_id, Female, AAE, LateTalker, CImplant, Birthdate = DOB) %>%
  distinct %>%
  arrange(short_id)

# One of the longitudinal children did a one-off in the dialect study. Don't
# need to add a row for them.
participants_to_add <- child_ids %>%
  filter(short_id != "458D") %>%
  readr::type_convert() %>%
  mutate(Child_Note = short_id)

rows_to_add <- participants_to_add %>%
  select(-short_id)

library("L2TDatabase")
l2t <- l2t_connect("./inst/l2t_db.cnf")

# append_rows_to_table(l2t, tbl_name = "Child", rows = rows_to_add)

# Get the newly created ChildIDs
tbl_child <- tbl(l2t, "Child") %>%
  collect() %>%
  filter(Child_Note %in% participants_to_add$short_id) %>%
  rename(short_id = Child_Note)

# Except for this older, already-created one
id_120L <- tbl(l2t, "ChildStudy") %>%
  filter(ShortResearchID == "120L") %>%
  distinct(ChildID) %>%
  collect()

tbl_120L <- tbl(l2t, "Child") %>%
  filter(ChildID == id_120L$ChildID) %>%
  collect() %>%
  mutate(short_id = "458D")

tbl_child_ids <- bind_rows(tbl_child, tbl_120L) %>%
  select(short_id, ChildID)

# Add new study names to database
dialect_studies <- data_frame(
  Study = c("DialectDensity", "DialectSwitch"),
  Study_Code = "D")
# append_rows_to_table(l2t, "Study", dialect_studies)

tbl_studies <- tbl(l2t, "Study") %>% collect


# Create the ChildID-StudyID pairings
child_studies_to_add <- study_ids %>%
  rename(Study = study) %>%
  left_join(tbl_child_ids) %>%
  left_join(tbl_studies) %>%
  select(ChildID, StudyID, ShortResearchID = short_id,
         FullResearchID = long_id) %>%
  arrange(StudyID, ShortResearchID)

# append_rows_to_table(l2t, "ChildStudy", child_studies_to_add)

tbl(l2t, "ChildStudy") %>% collect %>% tail
