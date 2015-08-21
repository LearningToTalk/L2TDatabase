
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
    row.names = FALSE)
}


# # Overwriting messes up all the data-types on the server :-/
# merge_values_into_table <- function(src, tbl_name, rows, key) {
#   # Unpack dplyr connection
#   if (inherits(src, "src_mysql")) {
#     db_name <- src$info$dbname
#     dplyr_src <- src
#     src <- src$con
#   }
#
#   # Confirm classes
#   assert_that(inherits(src, "MySQLConnection"), !inherits(src, "src"))
#
#   # Make sure data exists.
#   assert_that(not_empty(rows))
#
#   # Make sure table exists. Otherwise the dbWriteTable will create a new table.
#   assert_that(has_table(src, tbl_name))
#
#   # dbWriteTable doesn't like dplyr tbl objects
#   new_rows <- as.data.frame(rows, stringsAsFactors = FALSE)
#
#   # Make sure there is not a new column of data
#   curr_values <- collect(tbl_name %from% dplyr_src)
#   local_col_names <- names(rows)
#   remote_col_names <- names(curr_values)
#   assert_that(all(local_col_names %in% remote_col_names))
#
#   # Which columns have the new data?
#   cols_with_new_data <- setdiff(local_col_names, key)
#
#   # Keep the old, unaffected data
#   dont_drop <- setdiff(names(curr_values), cols_with_new_data)
#   old_data_to_keep <- select_(curr_values, .dots = dont_drop)
#
#   # Attach the new data to the old data
#   old_with_new <- inner_join(old_data_to_keep, new_rows, by = key) %>%
#     select_(.dots = remote_col_names) %>% as.data.frame(stringsAsFactors = FALSE)
#
#   # Overwriting messes up all the data-types on the server :-/
#   dbWriteTable(
#     conn = src,
#     name = tbl_name,
#     value = old_with_new,
#     append = FALSE,
#     overwrite = TRUE,
#     row.names = FALSE)
#
# }


