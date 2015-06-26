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

