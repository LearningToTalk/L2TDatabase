# Add Minimal Pairs administrations and responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("readr")
source("inst/paths.R")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file, "backend")
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Combine child-study-childstudy tbls
df_cds <- tbl(l2t, "ChildStudy") %>%
  left_join(tbl(l2t, "Study")) %>%
  left_join(tbl(l2t, "Child")) %>%
  select(ShortResearchID, FullResearchID, Study, ChildStudyID, Birthdate) %>%
  collect()

# Get minpair responses
df_mp <- read_csv(paths$minpairs) %>%
  mutate(ShortResearchID = str_extract(Eprime_Basename, "(?<=MINP_)\\d{3}\\w")) %>%
  rename(MinPair_Dialect = Dialect,
         MinPair_EprimeFile = Eprime_Basename,
         MinPair_Completion = Date)

# Make sure the CochlearMatching kids have the correct Study name
cimatching_ids <- df_cds %>%
  filter(Study == "CochlearMatching") %>%
  getElement("ShortResearchID")

df_mp <- df_mp %>%
  mutate(Study = ifelse(ShortResearchID %in% cimatching_ids, "CochlearMatching", Study))

# Make a table of administrations by getting one row per eprimefile
df_mp_admin <- df_mp %>%
  select(Study, ShortResearchID, MinPair_Dialect,
         MinPair_EprimeFile, MinPair_Completion) %>%
  distinct()

df_mp_admin %>% count(Study)
df_mp_admin %>% select(MinPair_EprimeFile) %>% distinct()

# Repeated filenames
df_repeated_filenames <- df_mp_admin %>%
  select(MinPair_Dialect, MinPair_EprimeFile, MinPair_Completion) %>%
  count(MinPair_EprimeFile) %>%
  filter(n != 1)
df_repeated_filenames

df_mp_admin <- df_mp_admin %>% anti_join(df_repeated_filenames)
df_mp <- df_mp %>% anti_join(df_repeated_filenames)

# Get adminstrations for children in database
df_with_ages <- df_mp_admin %>%
  inner_join(df_cds, by = c("Study", "ShortResearchID")) %>%
  select(Study, ShortResearchID, ChildStudyID, MinPair_Dialect, MinPair_EprimeFile,
         FullResearchID, MinPair_Completion, Birthdate) %>%
  mutate(
    MinPair_Age = chrono_age(Birthdate, MinPair_Completion),
    IDFromFile = str_replace(MinPair_EprimeFile, "MINP_", ""))

# Check for weird cases where id in filename doesn't match the FullResearchID.
# This are probably responses from children who did not receive it in their
# native dialect
df_id_mismatch <- df_with_ages %>%
  filter(IDFromFile != FullResearchID) %>%
  filter(Study != "DialectSwitch", Study != "MaternalEd")
df_id_mismatch %>% print(n = Inf)

df_can_be_added <- df_with_ages %>%
  select(-Birthdate, -Study, -FullResearchID,
         -ShortResearchID, -Birthdate, -IDFromFile)

# Find completely new records that need to be added
df_to_add <- find_new_rows_in_table(
  data = df_can_be_added,
  ref_data = l2t_dl$MinPair_Admin,
  required_cols = c("ChildStudyID", "MinPair_Dialect"))

# Add the rows
append_rows_to_table(l2t, "MinPair_Admin", df_to_add)




## Find records that need to be updated

# Redownload the table
df_remote_admin <- collect("MinPair_Admin" %from% l2t)

# Attach the database keys to latest data
df_remote_indices_admin <- df_remote_admin %>%
  select(ChildStudyID, MinPairID, MinPair_Dialect)

df_local_admin <- df_can_be_added %>%
  inner_join(df_remote_indices_admin) %>%
  arrange(MinPairID) %>%
  mutate(MinPair_Completion = format(MinPair_Completion))

# Keep just the columns in the latest data
df_remote_admin <- match_columns(df_remote_admin, df_local_admin) %>%
  # filter(ChildStudyID %in% df_local_admin$ChildStudyID) %>%
  arrange(MinPairID) %>%
  mutate(MinPair_Completion = format(MinPair_Completion))

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote_admin, df_local_admin, context = 0)
render_diff(daff)

# Or see them itemized in a long data-frame
create_diff_table(df_local_admin, df_remote_admin, "MinPairID")

overwrite_rows_in_table(l2t, "MinPair_Admin", rows = df_local_admin, preview = TRUE)
overwrite_rows_in_table(l2t, "MinPair_Admin", rows = df_local_admin, preview = FALSE)

# Check again
df_remote_admin <- collect("MinPair_Admin" %from% l2t)
anti_join(df_remote_admin, df_local_admin, by = "MinPairID")
anti_join(df_local_admin, df_remote_admin)





## Add trial-level data

# Attach local responses to remote administration records using the eprime
# filename, administration date and dialect
df_remote_admin <- collect("MinPair_Admin" %from% l2t) %>% type_convert()
df_remote_responses <- l2t_dl$MinPair_Responses

df_with_responses <- df_remote_admin %>%
  inner_join(df_mp, by = c("MinPair_Dialect", "MinPair_EprimeFile", "MinPair_Completion")) %>%
  match_columns(df_remote_responses) %>%
  mutate(Correct = as.numeric(Correct))

# Check for NAs
any(is.na(df_with_responses))
lapply(df_with_responses, unique)

# Which responses are missing
df_missing_responses <- df_with_responses %>% filter(is.na(Correct))
df_missing_responses

# Which administrations contain the missing reponses
df_remote_admin %>%
  inner_join(df_missing_responses)

# Remove duplicated rows
df_responses_to_add <- df_with_responses %>%
  anti_join(df_remote_responses, by = c("MinPairID", "Running", "Item1", "Item2", "Trial")) %>%
  anti_join(df_missing_responses, by = c("MinPairID", "Running", "Item1", "Item2", "Trial")) %>%
  arrange(MinPairID, Running, Trial)
df_responses_to_add

append_rows_to_table(l2t, "MinPair_Responses", df_responses_to_add)



## Check for responses that need to be updated

# Redownload the table
df_remote_responses <- collect("MinPair_Responses" %from% l2t)

remote_responses_indices <- describe_tbl(l2t, "MinPair_Responses") %>%
  filter(Index != "") %>%
  getElement("Field")

# Attach the database keys to latest data

df_remote_responses_indices <- df_remote_responses %>%
  left_join(df_remote_admin) %>%
  select(one_of(remote_responses_indices), Running, Trial)

df_local_responses <- df_with_responses %>%
  inner_join(df_remote_responses_indices) %>%
  arrange(MinPairID, ResponseID)

# Keep just the columns in the latest data
df_remote_responses <- df_remote_responses %>%
  match_columns(df_local_responses) %>%
  arrange(MinPairID, ResponseID)


# Preview changes with daff
library("daff")
daff <- diff_data(df_remote_responses, df_local_responses, context = 0)
render_diff(daff)

# Only subtractions for administrations that have been archived


df_remote_responses <- collect("MinPair_Responses" %from% l2t)
anti_join(df_remote_responses, df_local_responses, by = "MinPairID") %>%
  left_join(df_remote_admin) %>%
  distinct(MinPair_EprimeFile)
anti_join(df_local_responses, df_remote_responses)

df_remote_responses %>%
  left_join(df_remote_admin) %>%
  left_join(df_cds) %>%
  distinct(Study, ShortResearchID, MinPair_Dialect) %>%
  count(Study, MinPair_Dialect)
