#' Backup each tbl in the L2T database
#' @export
l2t_backup <- function(l2t_con, backup_dir) {
  # Create a folder for today's date
  stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
  this_backup_dir <- file.path(backup_dir, stamp)
  dir.create(this_backup_dir, showWarnings = FALSE, recursive = TRUE)

  # Backup each tbl in the database connection
  tbls <- src_tbls(l2t_con)
  dfs <- lapply(tbls, backup_tbl, src = l2t_con, output_dir = this_backup_dir)
  names(dfs) <- tbls
  dfs
}

#' Download a tbl from a db connection and write to a csv
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



#' Download a codebook for a database table
#' @export
#' @importFrom DBI dbGetQuery
describe_tbl <- function(src, tbl_name) {
  # Borrow connection if it's a dplyr connection. Not sure if this is dangerous
  if (inherits(src, "src_mysql")) src <- src$con
  assert_that(inherits(src, "MySQLConnection"))

  # Make sure table exists
  assert_that(has_table(src, tbl_name))

  # Get the table description
  this_query <- sprintf("SHOW FULL COLUMNS FROM %s", tbl_name)
  info <- dbGetQuery(src, statement = this_query)

  info <- info %>%
    mutate(Table = tbl_name) %>%
    select(Table, Field, Index = Key, DataType = Type, DefaultValue = Default,
           NullAllowed = Null, Description = Comment)

  info
}


#' Download a codebook for a database connection
#' @export
#' @importFrom DBI dbGetQuery
describe_db <- function(src) {
  # Borrow connection if it's a dplyr connection. Not sure if this is dangerous
  if (inherits(src, "src_mysql")) {
    db_name <- src$info$dbname
    src <- src$con
  }
  assert_that(inherits(src, "MySQLConnection"))

  # Get the description
  info <- dbGetQuery(src, statement = "SHOW TABLE STATUS")

  info <- info %>%
    mutate(Database = db_name) %>%
    select(Database, Table = Name, Rows, Description = Comment)

  info
}
