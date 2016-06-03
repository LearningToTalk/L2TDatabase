context("equality")


test_that("Equality operator", {

  # Works like ==
  expect_equal(0:3 %===% 0:3, 0:3 == 0:3)
  expect_equal(1:6 %===% 6:1, 1:6 == 6:1)

  # Works like !=
  expect_equal(1:3 %!==% 4:6, 1:3 != 4:6)
  expect_equal(1:6 %!==% 6:1, 1:6 != 6:1)

  # Length errors
  expect_error(1:3 %===% TRUE)
  expect_error(TRUE %===% 1:3)

  # Handles special values
  expect_true(NA %===% NA)
  expect_true(NaN %===% NaN)
  expect_true(Inf %===% Inf)
  expect_true(FALSE %===% FALSE)
  expect_true(NA_character_ %===% NA_real_)

  expect_true(NA %!==% NaN)
  expect_true(NA %!==% "NA")

  # Coercions -- not sure if we should allow these
  expect_true(1 %===% TRUE)
  expect_true(0 %===% FALSE)

  # NAs don't infect other values
  expect_equal(c(NA, 1) %===% c(1, NA), c(FALSE, FALSE))

  # We don't try to deal with NULLs
  expect_null(NULL %===% NULL)

})
