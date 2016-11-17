
library(L2TEprime)
library(L2TWordLists)
library(dplyr)
library(purrr)

tp1_rwr_files <- locate_files(
  file.path(l2t_eprime_data$rwr_dir, "TimePoint1/Recordings"),
  l2t_eprime_data$rwr_file
)

try_load_rwr_file <- safely(get_rwr_trial_info)
try_make_rwr_wordlist <- safely(lookup_rwr_wordlist)

tp1_rwr_data <- tp1_rwr_files %>%
  map(try_load_rwr_file)

# Check any errors
tp1_rwr_data %>%
  setNames(basename(tp1_rwr_files)) %>%
  map("error") %>%
  compact

# Create word lists
tp1_rwr_wordlists <- tp1_rwr_data %>%
  map("result") %>%
  map(try_make_rwr_wordlist)

tp1_rwr_wordlists %>%
  map("error") %>%
  compact

tp1_rwr_wordlists %>%
  map_df("result") %>%
  filter(is.na(TargetC))


create_wide_wordlist <- function(x) {
  left_join(x, lookup_rwr_wordlist(x))
}

wide_word_lists <- tp1_rwr_data  %>%
  map("result") %>%
  map_df(create_wide_wordlist)


wide_word_lists <- wide_word_lists %>%
  mutate(
    ResearchID = stringr::str_extract(Eprime.Basename, "\\d\\d\\d\\w"),
    Study = "TimePoint1") %>%
  rename(RealWordRep_Experiment = Experiment,
         RealWordRep_TimePoint = TimePoint,
         RealWordRep_Dialect = Dialect,
         RealWordRep_EprimeFile = Eprime.Basename,
         RealWordRep_Completion = Date,
         RealWordRep_Helper = Helper)

administrations <- wide_word_lists %>%
  select(Study, ResearchID, starts_with("RealWordRep")) %>%
  distinct

# Don't database participants who got the wrong version?
administrations <- administrations %>%
  filter(RealWordRep_TimePoint == 1)


library(L2TDatabase)
l2t <- l2t_connect("./inst/l2t_db.cnf")

dobs <- tbl(l2t, "Child") %>%
  left_join("ChildStudy" %from% l2t) %>%
  left_join("Study" %from% l2t) %>%
  select(ChildStudyID, Study, ResearchID = ShortResearchID, Birthdate) %>%
  collect()

administrations %>%
  anti_join(dobs) %>%
  {stopifnot(nrow(.) == 0)}

administrations <- administrations %>%
  left_join(dobs) %>%
  mutate(RealWordRep_Age = chrono_age(Birthdate, RealWordRep_Completion))

administrations %>%
  count(ResearchID) %>%
  filter(1 < n) %>%
  {stopifnot(nrow(.) == 0)}

remote_admins <- tbl(l2t, "RealWordRep_Admin") %>%
  collect %>%
  readr::type_convert()

# Check for children not found in database
local_admins <- match_columns(administrations, remote_admins)
local_admins %>% filter(is.na(ChildStudyID))


# Remove adminstrations already in database
rows_to_add <- local_admins %>%
  anti_join(remote_admins, by = c("ChildStudyID", "RealWordRep_EprimeFile")) %>%
  arrange(ChildStudyID, RealWordRep_EprimeFile)
rows_to_add

# Preview who is being added
inner_join(administrations, readr::type_convert(rows_to_add)) %>%
  select(ChildStudyID, Study, ResearchID, RealWordRep_EprimeFile) %>%
  as.data.frame %>%
  arrange(Study, ResearchID)

# There should not be any repeated file names
stopifnot(length(rows_to_add$RealWordRep_EprimeFile) == n_distinct(rows_to_add$RealWordRep_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "RealWordRep_Admin", rows_to_add)
tbl(l2t, "RealWordRep_Admin")


