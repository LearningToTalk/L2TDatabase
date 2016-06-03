
#' A stronger element-wise equality operators
#'
#' These operators work like \code{==} or \code{!=} but they handle comparison
#' with NA values. \code{1 \%===\% NA} is false and \code{NA \%===\% NA}.
#'
#' @param x,y vectors to be compared. They must have the same length.
#' @return \code{\%===\%} returns TRUE wherever is x[i] the same as y[i] and
#'   \code{\%!==\%} returns FALSE wherever is x[i] the same as y[i].
#' @export
#' @rdname equality
#' @examples
#' 1:3  %===% 1:3
#' #> [1] TRUE TRUE TRUE
#'
#' 1:3 %===% 4:6
#' #> [1] FALSE FALSE FALSE
#'
#' c(NA, NaN) %===% c(NA, NaN)
#' #> [1] TRUE TRUE
#'
#' c(NA, 1) %===% c(1, NA)
#' #> [1] FALSE FALSE
`%===%` <- function(x, y) {
  stopifnot(length(x) == length(y))
  Map(`%in%`, x, y) %>% unlist(use.names = FALSE)
}

#' @export
#' @rdname equality
#' @usage x \%!==\% y
`%!==%` <- Negate(`%===%`)





c(1, 2, 3, 4, NA, 7) %===% c(1, 2, 3, NA, NA, 6)
c(1, 2, 3, 4, NA, 7) %===% c(1, 2, 3, NA, NA, 6)


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
#' @note This function is only valid for years 1901 and beyond. Excel wrongly
#'   assumes 1900 was a leap year. See ?format.Date for more information.
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
#'
#' @param t1,t2 dates in "yyyy-mm-dd" format
#' @return the chronological ages in months. NA is returned if the age cannot be
#'   computed.
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
#'
#' # Multiple dates
#' t1 <- c("2012-01-20", "2014-02-10", "2010-10-10")
#' t2 <- c("2014-01-20", "2014-05-10", "2014-11-10")
#' chrono_age(t1, t2)
#' #> [1] 24  3 49
chrono_age <- function(t1, t2) {
  assert_that(length(t1) == length(t2))
  ages <- Map(failwith(NA, chrono_age_single), t1, t2)
  unlist(ages, use.names = FALSE)
}

#' Compute difference between two dates in months
#' @noRd
chrono_age_single <- function(t1, t2) {
  difference <- diff_date(t1, t2)
  12 * difference$y  + difference$m
}

#' Compute the difference between two dates
#' @noRd
diff_date <- function(t1, t2) {
  assert_that(length(t1) == 1, length(t2) == 1)

  if (is.na(t1) | is.na(t2)) {
    warning("Missing date: t1 = ", t1, ", t2 = ", t2, call. = FALSE)
    return(list(y = NA, m = NA, d = NA))
  }

  t1 <- ymd(t1)
  t2 <- ymd(t2)

  # Sort dates and convert to a list
  d1 <- as_date_list(min(t1, t2))
  d2 <- as_date_list(max(t1, t2))

  # Borrow a month
  if (d2$d < d1$d) {
    d2$m <- d2$m - 1
    d2$d <- d2$d + 30
  }

  # Borrow a year
  if (d2$m < d1$m) {
    d2$y <- d2$y - 1
    d2$m <- d2$m + 12
  }

  diff <- list(
    y = d2$y - d1$y,
    m = d2$m - d1$m,
    d = d2$d - d1$d
  )
  diff
}

# A lightweight data structure for hand-manipulating dates
as_date_list <- function(date) {
  list(y = year(date), m = month(date), d = day(date))
}
