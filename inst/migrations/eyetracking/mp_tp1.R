## Preamble
library("L2TDatabase")
library("dplyr")
library("tidyr")
library("stringr")

# A non-version-controlled file with db connection info and credentials
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")

# Other parameters for migration
db_name <- "l2t"
backup_dir <- "inst/backup"

## Download/backup db beforehand

# Connect and download each table to csv
l2t <- l2t_connect(cnf_file, db_name)
l2t_dl <- l2t_backup(l2t, backup_dir)

# If MySQL is available on the command line, dump the database too
dump_database(cnf_file, backup_dir, db_name)

## Prepare the data that will be imported
load("inst/migrations/eyetracking/mp_tp1.Rdata")

# Combine Child-Study-ChildStudy tbls to get identifiers used by the database
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)

cds <- cds %>% select(Study, ChildStudyID, ShortResearchID)

# Create columns that can join to the database identifiers
df_exps <- mp_tp1$tbl_exps %>%
  mutate(ShortResearchID = substr(Subject, 1, 4),
         Study = "TimePoint1") %>%
  select(-Subject)

# Attach the database IDs to the block names.
with_ids_df_exps <- left_join(df_exps, cds) %>%
  select(-Study, -ShortResearchID) %>%
  rename(Block_DateTime = DateTime)

# We have all the data that we could add to the database. We need to make sure
# it is not already there. Subtract current rows from new rows to see what data
# is new.
current_rows <- collect("LWL_Blocks" %from% l2t)
new_dates <- with_ids_df_exps %>%
  anti_join(current_rows, by = c("Block_DateTime"))
new_blocks <- with_ids_df_exps %>%
  anti_join(current_rows, by = c("Basename"))

# Find blocks with old names but new date times
updated_blocks <- filter(current_rows, Basename %in% new_dates$Basename)
updated_blocks

# Find blocks with old datetimes but new names
renamed_blocks <- filter(current_rows, Block_DateTime %in% new_blocks$Block_DateTime)
renamed_blocks

## These special cases require extra attention

# old names with new datetimes implies that the data has changed and we may need
# to cascade-delete the old data from all affected tables
stopifnot(nrow(updated_blocks) == 0)
# old datetimes with new names implies that we should update an existing row
# instead of adding a new one
stopifnot(nrow(renamed_blocks) == 0)

# New name AND New datetime
new_rows <- with_ids_df_exps %>%
  anti_join(current_rows, by = c("Basename", "Block_DateTime"))

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(ChildStudyID, Basename)
to_add

# Add to database
append_rows_to_table(l2t, "LWL_Blocks", to_add)




## LWL_BlockAttributes --------------------------------------------------------

# Now we can map the BlockIDs to the rows in the Trial dataframes and Block
# attributes data-frame, and those rows to the database.
blocks_in_db <- collect("LWL_Blocks" %from% l2t)

# Prepare the block attributes
df_exps_attrs <- mp_tp1$tbl_exps_attrs %>%
  mutate(Key = as.character(Key)) %>%
  rename(BlockAttributeName = Key, BlockAttributeValue = Value)

with_ids_df_exp_attrs <- left_join(df_exps_attrs, blocks_in_db)
filter(with_ids_df_exp_attrs, is.na(BlockID))

with_ids_df_exp_attrs <- with_ids_df_exp_attrs %>%
  select(BlockID, BlockAttributeName, BlockAttributeValue)

# Subtract current rows from new rows to see what data is new.
current_rows <- collect("LWL_BlockAttributes" %from% l2t)
new_rows <- anti_join(with_ids_df_exp_attrs, current_rows)

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(BlockID, BlockAttributeName, BlockAttributeValue)
to_add

# Add to database
append_rows_to_table(l2t, "LWL_BlockAttributes", to_add)




## LWL_Trials -----------------------------------------------------------------

# Prepare the block attributes
df_trials <- mp_tp1$tbl_trials %>%
  select(-TrialName)

with_ids_df_trials <- left_join(df_trials, blocks_in_db) %>%
  select(BlockID, TrialNo)

# Subtract current rows from new rows to see what data is new.
current_rows <- collect("LWL_Trials" %from% l2t)
new_rows <- anti_join(with_ids_df_trials, current_rows)

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(BlockID, TrialNo)
to_add

# Add to database
append_rows_to_table(l2t, "LWL_Trials", to_add)



## LWL_TrialAttributes --------------------------------------------------------

# Now we can map the TrialIDs to the rows in the Trial attributes df and add
# those rows to the database
trials_in_db <- tbl(l2t, "LWL_Trials") %>%
  left_join(tbl(l2t, "LWL_Blocks")) %>%
  select(BlockID, TrialID, Basename, TrialNo) %>%
  collect() %>%
  left_join(mp_tp1$tbl_trials)

# Prepare the trial attributes
df_trials_attr <- mp_tp1$tbl_trials_attr

# Attach indices from database
with_ids_df_trials_attrs <- df_trials_attr %>%
  left_join(trials_in_db) %>%
  select(TrialID, TrialAttributeName =  Key, TrialAttributeValue = Value)

# Subtract current rows from new rows to see what data is new.
current_rows <- collect("LWL_TrialAttributes" %from% l2t)
new_rows <- anti_join(with_ids_df_trials_attrs, current_rows)

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(TrialID, TrialAttributeName, TrialAttributeValue)
to_add

# Add to database
append_rows_to_table(l2t, "LWL_TrialAttributes", to_add)

# Test download size
lwl_attrs <- tbl(l2t, "LWL_TrialAttributes") %>%
  select(-TrialAttribute_Timestamp) %>%
  collect
pryr::object_size(lwl_attrs)





## LWL_Looks --------------------------------------------------------

df_looks <- mp_tp1$tbl_looks

# Attach Trials IDs
trials_in_db <- tbl(l2t, "LWL_Trials") %>%
  left_join(tbl(l2t, "LWL_Blocks")) %>%
  select(BlockID, TrialID, Basename, TrialNo) %>%
  collect() %>%
  left_join(mp_tp1$tbl_trials)

with_ids_df_looks <- left_join(df_looks, trials_in_db) %>%
  select(TrialID, Time, XMean:GazeByAOI)

# Subtract current rows from new rows to see what data is new.
current_rows <- collect("LWL_Looks" %from% l2t)
new_rows <- anti_join(with_ids_df_looks, current_rows)

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(TrialID, Time)
to_add

# Add to database
append_rows_to_table(l2t, "LWL_Looks", to_add)

# looks <- tbl(l2t, "LWL_Looks")
# all_looks <- collect(looks)
# pryr::object_size(all_looks)

