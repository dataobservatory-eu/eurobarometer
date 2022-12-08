sample_data <- read_sav_gesis(
  file = system.file("extdata", "ZA5933_sample.sav",
                     package = "eurobarometer"))

df <- sample_data
var_code_table(df, var_name = "d60")
cb <- codebook_create(df)
names(cb)

test_that("var_code_table()", {
  expect_equal(var_code_table(df, var_name = "d25")$survey
, rep("ZA5933", 4))
})

test_that("codebook_create()", {
  expect_true(all(names(df) %in% cb$var_name_orig))
  expect_equal(names(cb), c("survey", "var_name_orig", "var_label_orig", "val_code_orig", "val_label_orig"))
})
