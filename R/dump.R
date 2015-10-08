
#' Backup a database as a sequence of SQL statements
#'
#' This function calls \code{mysqldump} on a database connection described in a
#' cnf file. Consider reading the
#' \href{https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html}{documentation
#' of mysqldump}.
#'
#' The command-line call uses the \code{--single-transaction} flag because it
#' doesn't need LOCKED TABLES privilege.
#'
#' @inheritParams l2t_connect
#' @inheritParams l2t_backup
#' @return Nothing. Information about the dump output is printed to the console
#' @export
dump_database <- function(cnf_file, backup_dir, db_name = "l2t") {
  # Check that utility is installed and that only one DB is being backed up
  assert_that(on_path("mysqldump"))
  assert_that(length(db_name) == 1)

  # Prepare a timestamped filename for output
  stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
  out_file <- sprintf("%s_%s.sql", db_name, stamp)
  out_path <- file.path(backup_dir, out_file)

  # Use --single-transaction because it doesn't need the LOCKED TABLES privilege
  command <- sprintf("mysqldump --defaults-file=%s --single-transaction %s > %s",
                     cnf_file, db_name, out_path)
  shell(command)

  # Report status
  out_size <- sprintf("%.3f kB", file.size(out_path) / 1000)
  dump_lines <- readLines(out_path)

  message("Checking ", out_path)
  message("..file size: ", out_size)
  message("..line count: ", length(dump_lines))
  message("..first line: ", dump_lines[1])
  message("..final line: ", dump_lines[length(dump_lines)])
  invisible(NULL)
}
