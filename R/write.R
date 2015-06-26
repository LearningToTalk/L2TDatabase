

#' Append rows to a database table
#' @export
append_rows_to_table <- function(db_con, tbl_name, rows) {
  assert_that(inherits(db_con, "MySQLConnection"), !inherits(db_con, "src"))

  # Make sure table exists. Otherwise the dbWriteTable will create a new table.
  assert_that(has_table(db_con, tbl_name))

  # dbWriteTable doesn't like dplyr tbl objects
  rows <- as.data.frame(rows, stringsAsFactors = FALSE)

  dbWriteTable(
    conn = db_con,
    name = tbl_name,
    value = rows,
    append = TRUE,
    overwrite = FALSE,
    row.name = FALSE)
}
