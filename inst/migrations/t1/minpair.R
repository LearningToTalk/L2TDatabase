# Add tp1 min pairs responses to the database
library("dplyr")
library("L2TDatabase")
library("stringr")
library("tools")
library("rio")
source("inst/paths.R")

# Get minpair responses
all_responses <- import(paths$minpairs) %>%
  as_data_frame

# Limit to timepoint1
t1 <- all_responses %>% filter(Study == "TimePoint1")

# Make a table of administrations by getting one row per eprimefile
t1_admins <- t1 %>%
  select(Study,
         ShortResearchID = Participant_ID,
         Dialect,
         EprimeFile = Eprime.Basename,
         AdminDate = Date) %>%
  distinct

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Map from study to study number, from study/short research id to child-study
# id, from child-study id to research id
cds <- left_join(l2t_dl$ChildStudy, l2t_dl$Study)
with_ids <- t1_admins %>%
  inner_join(cds) %>%
  select(ChildStudyID, Dialect, EprimeFile, FullResearchID, AdminDate) %>%
  mutate(IDFromFile = str_replace(EprimeFile, "MINP_", ""))

# Weird cases where id in the filename doesn't match the FullResearchID
filter(with_ids, IDFromFile != FullResearchID)

# Remove duplicated rows
curr_admins <- l2t_dl$MinPair_Admin
with_ids <- match_columns(with_ids, curr_admins)
rows_to_add <- anti_join(with_ids, curr_admins) %>%
  arrange(ChildStudyID, AdminDate)
rows_to_add

# Add the rows
l2t_write <- l2t_writer_connect("inst/l2t_db.cnf")
append_rows_to_table(l2t_write, "MinPair_Admin", rows_to_add)
tbl(l2t, "MinPair_Admin")

# Now include the responses
t1 <- t1 %>% rename(EprimeFile = Eprime.Basename, AdminDate = Date)

# Attach local responses to remote administration records using the eprime
# filename, administration date and dialect
curr_admins <- collect("MinPair_Admin" %from% l2t)
curr_responses <- l2t_dl$MinPair_Responses
with_responses <- inner_join(curr_admins, t1) %>%
  match_columns(curr_responses) %>%
  mutate(Correct = as.numeric(Correct))

# Check for NAs
any(is.na(with_responses))

# Remove duplicated rows
responses_to_add <- with_responses %>%
  anti_join(curr_responses, by = c("MinPairID", "Running", "Item1", "Item2", "Trial")) %>%
  arrange(MinPairID, Running, Trial)
responses_to_add

append_rows_to_table(l2t_write, "MinPair_Responses", responses_to_add)

