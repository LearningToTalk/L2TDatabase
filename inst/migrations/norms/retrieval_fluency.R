# Add the Verbal Fluency norms table to the norms database

library("L2TDatabase")
library("readr")
library("dplyr")
library("tidyr")
source("inst/paths.R")

# Load hand-entered table of scores
norms <- read_csv(paths$vf_norms)

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

norms <- norms %>%
  rename(Raw = RetrievalRaw,
         AgeEq = AgeEquiv,
         GradeEq = GradeEquiv)

# Make sure only new data is being added
current_rows <- tbl(norm_db, "RetrievalFluency") %>% collect

new_rows <- anti_join(norms, current_rows) %>% arrange(Raw)

# Add to database
append_rows_to_table(norm_db, "RetrievalFluency", new_rows)

# Check that remote_rows minus local_rows is empty
current_rows <- tbl(norm_db, "RetrievalFluency") %>% collect
leftover_rows <- anti_join(new_rows, current_rows)
leftover_rows
