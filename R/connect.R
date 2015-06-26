#' Connect to the L2T database using a MySQL config file
#' @param cnf_file a MySQL config file
#' @return a dplyr database connection
#' @details
#' http://svitsrv25.epfl.ch/R-doc/library/RMySQL/html/RMySQL-package.html
#' @export
l2t_connect <- function(cnf_file) {
  assert_that(file.exists(cnf_file))

  src_mysql(
    user = NULL,
    password = NULL,
    dbname = "l2t",
    default.file = cnf_file)
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
