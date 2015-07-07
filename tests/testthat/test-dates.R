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
