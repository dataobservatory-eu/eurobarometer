sample_data <- read_sav_gesis(
  file = system.file("extdata", "ZA5933_sample.sav",
                     package = "eurobarometer"))

test_that("read_sav_gesis()", {
  expect_equal(attr(sample_data, "Identifier"), list(doi = "doi:10.4232/1.13044"))
})
