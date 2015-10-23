# Check that a table is part of a db connection (logic)
has_table <- function(db_con, tbl_name) {
  dbExistsTable(db_con, tbl_name)
}

# Check that a table is part of a db connection (error message)
on_failure(has_table) <- function(call, env) {
  # eval(call$x, env) looks up the value of 'x' in the environment of the failed
  # function call
  tbl_name <- eval(call$tbl_name, env)
  db_name <- dbGetInfo(eval(call$db_con, env), "dbname")
  sprintf("The table '%s' does not exist in the '%s' database",
          tbl_name, db_name)
}


# Check that a utility is available on the system path
# Taken from devtools::on_path
on_path <- function (...) {
  commands <- c(...)
  stopifnot(is.character(commands))
  unname(Sys.which(commands) != "")
}

on_failure(on_path) <- function(call, env) {
  # first element in a call is a function
  commands <- eval(call[[-1]], env)
  sprintf("%s not found on system path", commands)
}

# assert_that(on_path("pandoc"))
# #> Error: pandoc not found on system path
