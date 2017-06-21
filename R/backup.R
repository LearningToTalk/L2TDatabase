

#' Download a tbl from a db connection and write to a csv
#' @param tbl_name the name of a database table
#' @param src a dplyr-managed connection to a database
#' @param output_dir directory where the csv is to be saved
#' @return A copy of the table is downloaded from the database and returned. A
#'   blank data-frame is returned if the table could not be downloaded. The
#'   contents of the table are written to \code{[output_dir]/[tbl_name].csv}.
#' @export
backup_tbl <- function(tbl_name, src, output_dir) {
  # Try to download the tbl, defaulting to an empty data-frame
  try_tbl <- failwith(data_frame(), tbl)
  df <- collect(try_tbl(src, tbl_name))

  output_file <- file.path(output_dir, paste0(tbl_name, ".csv"))
  message("Writing ", output_file)
  write_csv(df, output_file)
  df
}

#' Download each tbl in a database and write to csv
#' @inheritParams backup_tbl
#' @param backup_dir location where to save the backed up table
#' @return Each table in the database is downloaded and saved via
#'   \code{backup_tbl}. The downloaded tables are returned in a list of
#'   dataframes. The csvs are saved together in a timestamped folder inside of
#'   the \code{backup_dir} folder, so the path to a particular's table's csv
#'   file would be \code{[backup_dir]/[timestamp]/[table_name].csv}.
#' @export
l2t_backup <- function(src, backup_dir) {
  # Create a folder for today's date
  stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
  this_backup_dir <- file.path(backup_dir, stamp)
  dir.create(this_backup_dir, showWarnings = FALSE, recursive = TRUE)
  metadata_dir <- file.path(this_backup_dir, "metadata")
  dir.create(metadata_dir, showWarnings = FALSE, recursive = TRUE)

  # Backup each tbl in the database connection
  tbls <- src_tbls(src)
  dfs <- lapply(tbls, backup_tbl, src = src, output_dir = this_backup_dir)
  names(dfs) <- tbls

  # Save the field descriptions
  descriptions <- bind_rows(Map(function(x) describe_tbl(src, x), tbls))
  description_csv <- file.path(metadata_dir, "field_descriptions.csv")
  message("Writing ", description_csv)
  write_csv(descriptions, path = description_csv)

  # Save the tbl descriptions
  db_description <- describe_db(src)
  db_description_csv <- file.path(metadata_dir, "table_descriptions.csv")
  message("Writing ", db_description_csv)
  write_csv(db_description, path = db_description_csv)

  dfs
}


#' Download a codebook for a database table
#' @inheritParams backup_tbl
#' @return A dataframe describing each column of a database table. Columns in
#'   the dataframe: Table, Field, Index (type of database index), (storage)
#'   DataType, DefaultValue, NullAllowed (whether blanks are allowed),
#'   Description (the comment field from the table structure).
#' @export
describe_tbl <- function(src, tbl_name) {
  # Borrow connection if it's a dplyr connection. Not sure if this is dangerous
  if (inherits(src, "src_dbi")) src <- src$con
  assert_that(inherits(src, "MySQLConnection"))

  # Make sure table exists
  assert_that(has_table(src, tbl_name))

  # Get the table description
  this_query <- sprintf("SHOW FULL COLUMNS FROM %s", tbl_name)
  info <- DBI::dbGetQuery(src, statement = this_query)

  info <- info %>%
    mutate(Table = tbl_name) %>%
    select(Table, Field, Index = Key, DataType = Type, DefaultValue = Default,
           NullAllowed = Null, Description = Comment)

  info
}


#' Download a codebook for a database
#' @inheritParams backup_tbl
#' @return A dataframe describing each table in a database. Columns in the
#'   dataframe: Database, Table, (number of) Rows, Description (comment field
#'   for the table)
#' @export
describe_db <- function(src) {
  # Unpack dplyr connection
  if (inherits(src, "src_dbi")) {
    dplyr_src <- src
    src <- src$con
    db_name <- DBI::dbGetInfo(src)[["dbname"]]
  }

  assert_that(inherits(src, "MySQLConnection"))

  # Get the description
  info <- DBI::dbGetQuery(src, statement = "SHOW TABLE STATUS")

  info <- info %>%
    mutate(Database = db_name) %>%
    select(Database, Table = Name, Rows, Description = Comment)

  info
}

