# Recreate all the views for the database

library(DBI)
library(stringr)

db <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "l2t",
  default.file = "./inst/l2t_db.cnf")

# Handle multiple statements by splitting files in a vector of statements...
get_queries <- function(path) {
  queries <- path %>%
    readr::read_file() %>%
    stringr::str_split(";(\n|\r)*\n") %>%
    unlist() %>%
    str_subset(".") %>%
    paste0(";")
  queries
}

# ...and running them one at a time
run_queries <- .  %>%
  get_queries() %>%
  lapply(function(x) dbExecute(db, x))


run_queries("./inst/views/caregiver_education.sql")

run_queries("./inst/views/eprime_tasks.sql")
run_queries("./inst/views/standardized_tests.sql")
run_queries("./inst/views/lena.sql")

run_queries("./inst/views/et_blocks.sql")

run_queries("./inst/views/tp1_scores.sql")
run_queries("./inst/views/tp2_scores.sql")
run_queries("./inst/views/tp3_scores.sql")

run_queries("./inst/views/ci_scores.sql")

run_queries("./inst/views/ages.sql")
