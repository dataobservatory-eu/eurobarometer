sample_data <- read_sav_gesis(
  file = system.file("extdata", "ZA5933_sample.sav",
                     package = "eurobarometer"))

df <- sample_data
var_code_table(df, var_name = "d60", freq = TRUE)
names(df)
cb <- codebook_create(df)

test_that("var_code_table()", {
  expect_equal(var_code_table(df, var_name = "d25")$survey
, rep("ZA5933", 4))
})

test_that("codebook_create()", {
  expect_equal(dataset::dataset_title(cb)$Title, "Codebook for Eurobarometer 82.4 (November-December 2014)")
  expect_equal(attr(cb, "RelatedIdentifier")$Identifier,"doi:10.4232/1.13044")
  expect_true(dataset::is.dataset(df))
  expect_true(all(names(df) %in% cb$var_name_orig))
  expect_equal(names(cb), c("survey", "var_name_orig", "var_label_orig", "val_code_orig", "val_label_orig"))
})

cbx <- codebook_create(df, freq=TRUE)
test_that("codebook_create(df, freq=TRUE)", {
  expect_equal(cbx$rel_freq[2:3], c(1,1))
})

