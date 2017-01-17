# Add the CTOPP norms table to the norms database to faciliate look-up of
# percentiles down the line.

library("L2TDatabase")
library("readr")
library("dplyr")
library("tidyr")
source("inst/paths.R")

# Load hand-entered table of scores
norms <- read_csv(paths$ctopp_norms)

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

elision_rows <- norms %>% filter(Subtest == "Elision") %>% select(-Subtest)
blending_rows <- norms %>% filter(Subtest == "Blending") %>% select(-Subtest)

memory_rows <- norms %>%
  filter(Subtest == "Memory") %>%
  select(-Subtest, -AgeEq, -GradeEq)

# Make sure only new data is being added
elision_current_rows <- tbl(norm_db, "CTOPP_Elision") %>% collect()
elision_new_rows <- anti_join(elision_rows, elision_current_rows) %>%
  arrange(Age, Raw)

blending_current_rows <- tbl(norm_db, "CTOPP_Blending") %>% collect()
blending_new_rows <- anti_join(blending_rows, blending_current_rows) %>%
  arrange(Age, Raw)

memory_current_rows <- tbl(norm_db, "CTOPP_Memory") %>% collect()
memory_new_rows <- anti_join(memory_rows, memory_current_rows) %>%
  arrange(Age, Raw)

# Add to database
append_rows_to_table(norm_db, "CTOPP_Blending", blending_new_rows)
append_rows_to_table(norm_db, "CTOPP_Elision", elision_new_rows)
append_rows_to_table(norm_db, "CTOPP_Memory", memory_new_rows)

# Check that remote_rows minus local_rows is empty
current_rows <- tbl(norm_db, "CTOPP_Blending") %>% collect
leftover_rows <- anti_join(blending_rows, current_rows)
leftover_rows

current_rows <- tbl(norm_db, "CTOPP_Elision") %>% collect
leftover_rows <- anti_join(elision_rows, current_rows)
leftover_rows

current_rows <- tbl(norm_db, "CTOPP_Memory") %>% collect
leftover_rows <- anti_join(memory_rows, current_rows)
leftover_rows

## Demos of how to use the norms
norms <- current_rows %>%
  select(-CTOPP_ElisionID)

# General filtering
norms %>%
  filter(Raw == 4, Age %in% c(48, 54, 60))

