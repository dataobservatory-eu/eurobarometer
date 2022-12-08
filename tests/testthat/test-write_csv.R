sample_data <- read_sav_gesis(
   file = system.file("extdata", "ZA5933_sample.sav",
                      package = "eurobarometer"))
write_csv(sample_data, file = file.path(tempdir(), "sample.csv"))
re_read_sample <- read.csv(file = file.path(tempdir(), "sample.csv"))

test_that("write_csv() no declared vars remain:", {
  expect_equal(sum(vapply(re_read_sample, declared::is.declared, logical(1)))
, 0)
})

'https://search.gesis.org/variables/exploredata-ZA5688_Vard25'

