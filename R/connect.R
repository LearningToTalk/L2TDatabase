#' Connect to the L2T database using a MySQL config file
#' @param cnf_file a MySQL config file
#' @param db_name the name of the database to connect to. Defaults to "l2t".
#' @return a dplyr database connection
#' @details
#' http://svitsrv25.epfl.ch/R-doc/library/RMySQL/html/RMySQL-package.html
#' @export
l2t_connect <- function(cnf_file, db_name = "l2t") {
  assert_that(file.exists(cnf_file))
  src_mysql(
    user = NULL,
    password = NULL,
    dbname = db_name,
    default.file = cnf_file)
}

#' Connect to the L2T database with RMySQL
#' @inheritParams l2t_connect
#' @return a database connection via RMySQL capable of writing to the database.
#' @export
l2t_writer_connect <- function(cnf_file, db_name = "l2t") {
  dbConnect(MySQL(), dbname = db_name, default.file = cnf_file)
}

#' Create a MySQL config file
#' @param dest file-name where to save the .cnf file
#' @param user login credential for db connection. Defaults to "".
#' @param password login credential for db connection. Defaults to "".
#' @param host hostname of the db connection. Defaults to "".
#' @param port port for the db connection. Defaults to 3306.
#' @param db name of the database. Defaults to "".
#' @return the lines of the populated .cnf template file are returned. These
#'   lines are also written to the file named in \code{dest} and printed to the
#'   console.
#' @export
#' @importFrom stringr str_replace_all
make_cnf_file <- function(dest = "db.cnf", user = "", password = "",
                          host = "", port = 3306, db = "") {
  # Template for a cnf file
  lines <- "[client]
  user=%s
  password=%s
  host=%s
  port=%s

  [rs-dbi]
  database=%s"

  # Trim leading white-space, populate template
  cnf <- lines %>%
    str_replace_all(" ", "") %>%
    sprintf(user, password, host, port, db)

  # Write output
  message("Writing to ", dest, ":\n", cnf)
  writeLines(cnf, dest)
  cnf
}
