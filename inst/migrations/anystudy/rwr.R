
library(L2TEprime)
library(L2TWordLists)
library(dplyr)
library(purrr)

tp1_rwr_files <- locate_files(
  file.path(l2t_eprime_data$rwr_dir, "TimePoint1/Recordings"),
  l2t_eprime_data$rwr_file
)

tp2_rwr_files <- locate_files(
  file.path(l2t_eprime_data$rwr_dir, "TimePoint2/Recordings"),
  l2t_eprime_data$rwr_file
)

tp3_rwr_files <- locate_files(
  file.path(l2t_eprime_data$rwr_dir, "TimePoint3/Recordings"),
  l2t_eprime_data$rwr_file
)

try_load_rwr_file <- safely(get_rwr_trial_info)
try_make_rwr_wordlist <- safely(lookup_rwr_wordlist)

files <- list(
  TimePoint1 = tp1_rwr_files %>% set_names(basename(.)),
  TimePoint2 = tp2_rwr_files %>% set_names(basename(.)),
  TimePoint3 = tp3_rwr_files %>% set_names(basename(.))
)

# Load the data for each study
rwr_data <- files %>%
  at_depth(2, try_load_rwr_file)

# Check each sublist for errors
check_errors <- . %>% map("error") %>% compact
rwr_data %>% map(check_errors)

# Create wordlists for each sublist
create_wordlist <- . %>% map("result") %>% map(try_make_rwr_wordlist)
rwr_wordlists <- rwr_data %>%
  map(create_wordlist)

rwr_wordlists %>% map(check_errors)


create_wide_wordlist <- function(x) {
  left_join(x, lookup_rwr_wordlist(x))
}

create_dataframe_for_study <- . %>%
  map("result") %>%
  map_df(create_wide_wordlist)

wide_word_lists <- rwr_data %>%
  map(create_dataframe_for_study) %>%
  bind_rows(.id = "Study")

wide_word_lists <- wide_word_lists %>%
  mutate(
    ResearchID = stringr::str_extract(Eprime.Basename, "\\d\\d\\d\\w")) %>%
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
version_check <- tibble::tribble(
  ~ Study,        ~ RealWordRep_TimePoint,
  "TimePoint1",   1,
  "TimePoint2",   2,
  "TimePoint3",   3
)

wrong_block_given <- administrations %>% anti_join(version_check)
wrong_block_given

administrations <- administrations %>% anti_join(wrong_block_given)


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
  count(ResearchID, ChildStudyID) %>%
  filter(1 < n) %>%
  {stopifnot(nrow(.) == 0)}

remote_admins <- tbl(l2t, "RealWordRep_Admin") %>%
  collect %>%
  readr::type_convert()

# Remove adminstrations already in database
rows_to_add <- find_new_rows_in_table(
  data = administrations,
  ref_data = remote_admins,
  required_cols = c("ChildStudyID"),
  extra_cols = c("RealWordRep_EprimeFile", "RealWordRep_Completion"))
rows_to_add

# Preview who is being added
inner_join(administrations, readr::type_convert(rows_to_add)) %>%
  select(ChildStudyID, Study, ResearchID, RealWordRep_EprimeFile) %>%
  arrange(Study, ResearchID) %>%
  print(n = 100)

# There should not be any repeated file names
stopifnot(length(rows_to_add$RealWordRep_EprimeFile) == n_distinct(rows_to_add$RealWordRep_EprimeFile))

# Add the rows
append_rows_to_table(l2t, "RealWordRep_Admin", rows_to_add)
tbl(l2t, "RealWordRep_Admin")


