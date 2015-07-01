# Merge list y into list x
merge_lists <- function(x, y) {
  x[names(y)] <- y
  x
}


#' Make columns in one data-frame match those in a second data-frame
#' @export
match_columns <- function(df1, df2) {
  matching_names <- intersect(colnames(df1), colnames(df2))
  df1[matching_names]
}

#' Grab a table from a source
#' @export
`%from%` <- function(tbl_name, db_con) {
  tbl(db_con, tbl_name)
}
