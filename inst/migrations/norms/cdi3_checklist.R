# Add the CDI-3 norms table to the norms databaset to faciliate look-up of
# percentiles down the line.

library("L2TDatabase")
library("readr")
library("dplyr")
library("tidyr")
source("inst/paths.R")

# Load hand-entered table of scores
norms <- read_csv(paths$cdi_norms) %>%
  select(-Test) %>%
  mutate(Gender = ifelse(Gender == "Girl", "Female", "Male"))

# Girls know more words btw, but the gap narrows over time
norms %>%
  group_by(Age, Gender) %>%
  summarise(Mean = mean(Score)) %>%
  spread(Gender, Mean)

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

# Make sure only new data is being added
current_rows <- tbl(norm_db, "CDI3_Checklist") %>% collect
new_rows <- anti_join(norms, current_rows)

# Add to database
append_rows_to_table(norm_db, "CDI3_Checklist", new_rows)

current_rows <- tbl(norm_db, "CDI3_Checklist") %>% collect
leftover_rows <- anti_join(norms, current_rows)

## Demos of how to use the norms
norms <- current_rows %>%
  select(-CDI3_ChecklistID) %>%
  arrange(Gender, Age, Score)

# General filtering
filter(norms, Gender == "Male", Age == 30, Score < 30)
