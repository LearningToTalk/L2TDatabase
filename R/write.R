
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


#' Compare two tables to find new records
#' @param data data-frame to check for changes
#' @param ref_data a reference data-frame
#' @param required_cols the names of columns that both tables to need to have
#'   and should only have non-NA values for.
#' @param extra_cols the names of additional columns which should have the same
#'   values in each table
#' @return a data-frame of rows of rows that are in `data` but not in `ref_data`
#' @export
find_new_rows_in_table <- function(data, ref_data, required_cols, extra_cols = character(0)) {
  # Make the two tables have the same columns
  data_conformed <- match_columns(data, ref_data)

  # Check that the required columns have values
  find_na_rows <- function(col_name, df) which(is.na(df[[col_name]]))
  na_rows <- required_cols %>%
    lapply(find_na_rows, df = data_conformed) %>%
    unlist

  if (length(na_rows) != 0) {
    col_list <- deparse(required_cols)
    row_list <- deparse(sort(unique(na_rows)))
    stop("Missing values in required columns: ", col_list,
         "\n  Affected rows: ", row_list, call. = FALSE)
  }

  # Columns that need to match in both tables
  by <- c(required_cols, extra_cols)

  # Create a list of formulas from col names. Needed to get arrange_ to sort
  # with these columns.
  by_list <- lapply(paste0("~ ", by), as.formula)

  data_conformed %>%
    anti_join(ref_data, by = by) %>%
    arrange_(.dots = by_list)
}











#' Update records in a table
#' @param src a dplyr-managed database connection or a MySQLConnection
#' @param tbl_name name of the table to update
#' @param rows a data-frame of rows with new data
#' @param preview whether the update should be performed or just previewed
#' @return TRUE if the update succeeded.
#' @export
overwrite_rows_in_table <- function(src, tbl_name, rows, preview = TRUE) {
  # Unpack dplyr connection
  if (inherits(src, "src_mysql")) {
    db_name <- src$info$dbname
    dplyr_src <- src
    src <- src$con
  }

  # Confirm classes
  assert_that(inherits(src, "MySQLConnection"), !inherits(src, "src"))

  # Make sure data exists.
  assert_that(not_empty(rows))

  # Make sure table exists.
  assert_that(has_table(src, tbl_name))

  # Make sure there are not any new columns of data
  ref_rows <- collect(tbl_name %from% dplyr_src)
  rows <- match_columns(rows, ref_rows)

  # Need at least two columns: Primary key and field to be updated
  assert_that(2 <= ncol(rows))

  # Locate the primary key
  tbl_desc <- describe_tbl(src, tbl_name)
  tbl_indices <- tbl_desc %>%
    select(Field, Index) %>%
    filter(Index != "")

  # We assume there is just one field for the primary key
  tbl_primary_key <- tbl_indices %>%
    filter(Index == "PRI")
  assert_that(nrow(tbl_primary_key) == 1)

  primary_key <- tbl_primary_key$Field
  assert_that(primary_key %in% names(rows))

  # Get the records that need to be updated
  ref_rows <- ref_rows %>%
    semi_join(rows, by = primary_key) %>%
    match_columns(rows)

  # Make sure classes match
  for (col in names(rows)) {
    class(rows[[col]]) <- class(ref_rows[[col]])
  }

  # Determine which rows changed
  df_diff <- create_diff_table(rows, ref_rows, primary_key)
  if (nrow(df_diff) == 0) {
    message("No rows need to be updated")
    return(FALSE)
  }

  # Create a version of the conversion function with some arguments filled in
  partial_convert <- function(tbl_diff) {
    convert_diff_to_update_statement(src, tbl_name, primary_key, tbl_diff)
  }

  # Create a set of SQL UPDATE statements from the diff summary
  queries_to_run <- df_diff %>%
    split(.[[primary_key]]) %>%
    lapply(partial_convert)

  if (preview) {
    message("Previewing queries")
    for (query in queries_to_run) {
      message("\t", query)
    }
  } else {
    message("Performing queries")
    for (query in queries_to_run) {
      message("\t", query)
      result <- dbGetQuery(src, statement = query)
    }
  }

  TRUE
}

#' Convert a summary of diffs into a SQL UPDATE query
convert_diff_to_update_statement <- function(src, tbl_name, primary_key, tbl_diff) {
  # Only update one record
  records_to_update <- tbl_diff %>%
    select(one_of(primary_key)) %>%
    distinct
  assert_that(nrow(records_to_update) == 1)

  # Escape values
  tbl_diff$NewVersionEsc <- sql_escape_string(src, tbl_diff$NewVersion)
  tbl_diff$FieldEsc <- sql_escape_ident(src, tbl_diff$Field)
  tbl_name_esc <- sql_escape_ident(src, tbl_name)
  primary_key_esc <- sql_escape_ident(src, primary_key)

  # Generate the assignment portion
  assignments <- sprintf("%s = %s", tbl_diff$FieldEsc, tbl_diff$NewVersionEsc)
  assign_part <- paste0(assignments, collapse = ", ")

  # Assuming that the primary key is a single field
  key_value <- tbl_diff[[primary_key]] %>%
    unique %>%
    sql_escape_string(src, .)

  where_part <- sprintf("%s = %s", primary_key_esc, key_value)

  sprintf("UPDATE %s SET %s WHERE %s",
          tbl_name_esc,
          assign_part,
          where_part)
}


#' Summarize the changes between two data-frames
#' @param data a data-frame
#' @param ref_data a reference version of the data-frame
#' @param primary_key the name of a column which is used to unique identify rows
#'   in the data
#' @return a data-frame with the primary key column(s), and the columns Field,
#'   OldVersion and NewVersion showing the differences between the two
#'   data-frames
#' @export
create_diff_table <- function(data, ref_data, primary_key) {
  # Identify rows that had values change
  changes <- find_updates_in_daff(ref_data, data) %>%
    select(one_of(primary_key))

  # Return an empty data-frame with the expected columns if nothing changed
  if (nrow(changes) == 0) {
    changes$Field <- character(0)
    changes$ReferenceVersion <- character(0)
    changes$NewVersion <- character(0)
    return(changes)
  }

  # Combine the old and new data together
  ref_data$TblVersion <- "Reference"
  data$TblVersion <- "New"
  combined <- bind_rows(ref_data, data) %>%
    semi_join(changes, by = primary_key)

  # Exclude the primary key column from the comparison
  var_names <- setdiff(names(combined), c("TblVersion", primary_key))
  df <- combined %>%
    # Gather the data into a long-format data-frame
    tidyr::gather_("Field", "Value", gather_cols = var_names) %>%
    tidyr::spread_("TblVersion", "Value", convert = TRUE) %>%
    # Keep all rows where `Reference` is not the same as `New`
    rowwise %>%
    filter(Reference %nin% New) %>%
    ungroup

  # Tidy up
  df <- df %>%
    rename(ReferenceVersion = Reference, NewVersion = New) %>%
    select(one_of(primary_key), Field, ReferenceVersion, NewVersion) %>%
    mutate(Field = as.character(Field))

  df
}

# Keep just the x->y rows in a daff
find_updates_in_daff <- function(ref_data, new_data) {
  this_daff <- daff::diff_data(ref_data, new_data, context = 0)

  # Determine the number of columns in the diff csv
  num_cols <- suppressWarnings({
    this_daff$to_csv() %>%
      read_csv(skip = 0) %>%
      ncol
  })

  # Locate header line. Sometimes it's the second line if there have been
  # columns inserted/removed
  at_at_line <- this_daff$to_csv() %>%
    read_lines %>%
    stringr::str_detect("@@")

  header_row <- seq_along(at_at_line)[at_at_line]
  stopifnot(length(header_row) == 1)
  skip_to_find_header <- header_row - 1

  # Read the diff csv, ignoring the scheme row and interpreting all columns as
  # strings
  col_types <- rep_len("c", num_cols) %>% paste0(collapse = "")
  updated_rows <- this_daff$to_csv() %>%
    read_csv(skip = skip_to_find_header, col_types = col_types) %>%
    filter(`@@` == "->") %>%
    type_convert

  updated_rows
}








#' Remove records in a table
#' @param src a dplyr-managed database connection or a MySQLConnection
#' @param tbl_name name of the table to modify
#' @param rows a data-frame of rows to remove
#' @param guard whether to prevent the delete statement (the default) if it
#'   would delete all rows in the table
#' @param preview whether the delete should be performed or just previewed
#' @return TRUE if the delete succeeded.
#' @export
delete_rows_in_table <- function(src, tbl_name, rows, guard = TRUE, preview = TRUE) {
  # Unpack dplyr connection
  if (inherits(src, "src_mysql")) {
    db_name <- src$info$dbname
    dplyr_src <- src
    src <- src$con
  }

  # Confirm classes
  assert_that(inherits(src, "MySQLConnection"), !inherits(src, "src"))

  # Make sure data exists.
  assert_that(not_empty(rows))

  # Make sure table exists.
  assert_that(has_table(src, tbl_name))

  # Make sure there are not any new columns of data
  ref_rows <- collect(tbl_name %from% dplyr_src)
  rows <- match_columns(rows, ref_rows)

  # Locate the primary key
  tbl_desc <- describe_tbl(src, tbl_name)
  tbl_indices <- tbl_desc %>%
    select(Field, Index) %>%
    filter(Index != "")

  # We assume there is just one field for the primary key
  tbl_primary_key <- tbl_indices %>%
    filter(Index == "PRI")
  assert_that(nrow(tbl_primary_key) == 1)

  primary_key <- tbl_primary_key$Field
  assert_that(primary_key %in% names(rows))

  rows_to_delete <- ref_rows %>%
    semi_join(rows, by = primary_key) %>%
    match_columns(rows)


  if (guard && nrow(rows_to_delete) == nrow(ref_rows)) {
    stop("Aborting -- this query would remove every row in the table!")
  }

  # Create a version of the conversion function with some arguments filled in
  partial_convert <- function(tbl_row) {
    convert_row_to_delete_statement(src, tbl_name, primary_key, tbl_row)
  }

  # Create a set of SQL DELETE statements
  queries_to_run <- rows_to_delete %>%
    split(.[[primary_key]]) %>%
    lapply(partial_convert)

  if (preview) {
    message("Previewing queries")
    for (query in queries_to_run) {
      message("\t", query)
    }
  } else {
    message("Performing queries")
    for (query in queries_to_run) {
      message("\t", query)
      result <- dbGetQuery(src, statement = query)
    }
  }

  TRUE
}

#' Create a SQL DELETE query from a row of a dataframe
convert_row_to_delete_statement <- function(src, tbl_name, primary_key, tbl_row) {
  # Only update one record
  records_to_delete <- tbl_row %>%
    select(one_of(primary_key)) %>%
    distinct()
  assert_that(nrow(records_to_delete) == 1)

  # Escape values
  tbl_name_esc <- sql_escape_ident(src, tbl_name)
  primary_key_esc <- sql_escape_ident(src, primary_key)

  # Assuming that the primary key is a single field
  key_value <- tbl_row[[primary_key]] %>%
    unique() %>%
    sql_escape_string(src, .)

  where_part <- sprintf("%s = %s", primary_key_esc, key_value)

  sprintf("DELETE FROM %s WHERE %s",
          tbl_name_esc,
          where_part)
}




























