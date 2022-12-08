x <- declared(
  c(1:5, -1),
  labels = c(Good = 1, Bad = 5, DK = -1),
  na_values = -1
 )
 attr(x, "label") <- "Example"


test_that("as_factor() works", {
  expect_equal(attr(as_factor(x), "label"), "Example" )
  expect_equal(class(as_factor(x)), "factor")
})


test_that("as_character() works", {
  expect_equal(attr(as_character(x), "label"), "Example" )
  expect_equal(class(as_character(x)), "character")
})

num_x <- c(1,2,3,4,5,NA_real_)
attr(num_x, "label") <- "Example"

test_that("as_numeric() works", {
  expect_equal(attr(as_numeric(x), "label"), "Example" )
  expect_equal(class(as_numeric(x)), "numeric")
  expect_equal(as_numeric(x), num_x )
})
