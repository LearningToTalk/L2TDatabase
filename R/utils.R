

`%nin%` <- Negate(`%in%`)



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

#' Convert an Excel date to a POSIX date
#'
#' Excel stores dates as an integer representing the number of days since
#' 1/1/1900. Undo that. See
#' http://www.exceltactics.com/definitive-guide-using-dates-times-excel/
#'
#' @param dates a vector of dates (either numeric or character) originating
#'   from an Excel spreadsheet.
#' @return the dates converted to POSIXct objects (see ?DateTimeClasses)
#' @export
#' @examples
#' undo_excel_date("41659")
#' #> "2014-01-20 UTC"
#' undo_excel_date(41534)
#' #> "2013-09-17 UTC"
undo_excel_date <- function(dates) {
  ymd(as.Date(as.numeric(dates), origin = "1899-12-30"))
}



#' Compute chronological age in months
#'
#' Ages are rounded down to the nearest month. A difference of 20 months, 29
#' days is interpreted as 20 months.
#' @param t1,t2 dates in ymd format
#' @return the chronological age in months
#' @export
#' @examples
#' # Two years exactly
#' chrono_age("2014-01-20", "2012-01-20")
#' #> 24
#'
#' # Shift a year
#' chrono_age("2014-01-20", "2013-01-20")
#' #> 12
#' chrono_age("2014-01-20", "2011-01-20")
#' #> 36
#'
#' # Shift a month
#' chrono_age("2014-01-20", "2012-02-20")
#' #> 23
#' chrono_age("2014-01-20", "2011-12-20")
#' #> 25
#'
#' # 3 months exactly
#' chrono_age("2014-05-10", "2014-02-10")
#' #> 3
#'
#' # Borrow a month when the earlier date has a later day
#' chrono_age("2014-05-10", "2014-02-11")
#' #> 2, equal to 2 months, 29 days rounded down to nearest month
#'
#' # Inverted argument order
#' chrono_age("2012-01-20", "2014-01-20")
#' #> 24
chrono_age <- function(t1, t2) {
  assert_that(!is.na(t1), !is.na(t2))
  assert_that(length(t1) == 1, length(t2) == 1)

  t1 <- ymd(t1)
  t2 <- ymd(t2)
  timespan <- as.period(interval(t1, t2))

  months <- abs(timespan %/% months(1))
  months
}
