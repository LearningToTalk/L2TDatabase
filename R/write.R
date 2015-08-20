
#' Append rows to a database table
#' @param src a dplyr-managed database connection or a MySQLConnection
#' @param tbl_name name of the table to update
#' @param rows a data-frame of new rows
#' @return TRUE if the update succeeded
#' @export
append_rows_to_table <- function(src, tbl_name, rows) {
  # Unpack dplyr connection
  if (inherits(src, "src_mysql")) {
    db_name <- src$info$dbname
    src <- src$con
  }

  # Confirm classes
  assert_that(inherits(src, "MySQLConnection"), !inherits(src, "src"))

  # Make sure data exists.
  assert_that(not_empty(rows))

  # Make sure table exists. Otherwise the dbWriteTable will create a new table.
  assert_that(has_table(src, tbl_name))

  # dbWriteTable doesn't like dplyr tbl objects
  rows <- as.data.frame(rows, stringsAsFactors = FALSE)

  dbWriteTable(
    conn = src,
    name = tbl_name,
    value = rows,
    append = TRUE,
    overwrite = FALSE,
    row.name = FALSE)
}
