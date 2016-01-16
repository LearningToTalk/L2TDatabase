context("dates")

test_that("Chronological age in months", {
  # Two years exactly
  expect_equal(chrono_age("2014-01-20", "2012-01-20"), 24)

  # Shift a year
  expect_equal(chrono_age("2014-01-20", "2013-01-20"), 12)
  expect_equal(chrono_age("2014-01-20", "2011-01-20"), 36)

  # Shift a month
  expect_equal(chrono_age("2014-01-20", "2012-02-20"), 23)
  expect_equal(chrono_age("2014-01-20", "2011-12-20"), 25)

  # 3 months exactly
  expect_equal(chrono_age("2014-05-10", "2014-02-10"), 3)

  # Borrow a month when the earlier date has a later day
  expect_equal(chrono_age("2014-05-10", "2014-02-11"), 2)

  # Reversed arguments
  expect_equal(chrono_age("2012-01-20", "2014-01-20"), 24)
})

test_that("Excel date recovery", {
  # xls file
  dates <- readxl::read_excel("data/dates.xls")

  # parse expected date (string -> date)
  dates$exp_date <- as.Date(dates$Expected)

  # convert excel date (string -> time -> date)
  dates$new_date <- suppressWarnings(as.Date(undo_excel_date(dates$Date)))

  expect_equal(dates$new_date, dates$exp_date)

  # xlsx file
  x_dates <- readxl::read_excel("data/dates.xlsx")

  # parse expected date (string -> date)
  x_dates$exp_date <- as.Date(x_dates$Expected)

  # convert excel date (string -> time -> date)
  x_dates$new_date <- suppressWarnings(as.Date(undo_excel_date(x_dates$Date)))

  expect_equal(x_dates$new_date, x_dates$exp_date)
})
