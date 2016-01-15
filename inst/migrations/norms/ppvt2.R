# Add the PPVT norms table to the norms databaset to faciliate look-up of
# percentiles down the line.

library("L2TDatabase")
library("readr")
library("dplyr")
library("tidyr")
source("inst/paths.R")

# Load hand-entered table of scores
norms <- read_csv(paths$ppvt_norms)

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

# Make sure only new data is being added
current_rows <- tbl(norm_db, "PPVT4") %>% collect
new_rows <- norms %>%
  anti_join(current_rows) %>%
  arrange(Form, Age, Raw)

# Add to database
append_rows_to_table(norm_db, "PPVT4", new_rows)

# Check that remote_rows minus local_rows is empty
current_rows <- tbl(norm_db, "PPVT4") %>% collect
leftover_rows <- anti_join(norms, current_rows)
leftover_rows

## Demos of how to use the norms
norms <- tbl(norm_db, "PPVT4") %>% collect %>% select(-PPVT2ID)

# General filtering
norms %>%
  filter(Raw == 30, Age %in% c(30, 40, 50))
