#' Backup each tbl in the L2T database
#' @export
l2t_backup <- function(l2t_con, backup_dir) {
  # Create a folder for today's date
  stamp <- format(Sys.time(), "%Y_%m_%d")
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
