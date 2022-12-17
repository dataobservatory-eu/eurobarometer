copy_to_tempdir_test ( "ZA5933_sample.sav")
test_file_1 <- file.path(tempdir(), "test", "ZA5933_sample.sav")
sample_data <- read_sav_gesis(test_file_1)

test_that("dir_spss_files()", {
  expect_equal(as.character(dir_spss_files (file.path(tempdir(), "test"))), file.path(tempdir(), "test", "ZA5933_sample.sav") )
})


df <- sample_data
var_code_table(df, var_name = "d60", freq = TRUE)
cb <- codebook_create(df)

test_that("var_code_table()", {
  expect_equal(var_code_table(df, var_name = "d25")$survey
, rep("10.4232/1.13044", 4))
})

test_that("codebook_create()", {
  expect_equal(dataset::dataset_title(cb)$Title, "Codebook for Eurobarometer 82.4 (November-December 2014)")
  expect_equal(attr(cb, "RelatedIdentifier")$Identifier,"ZA5933")
  expect_true(dataset::is.dataset(df))
  expect_true(all(names(df) %in% cb$var_name_orig))
  expect_equal(names(cb), c("survey", "ZACAT", "var_name_orig", "var_label_orig", "val_code_orig", "val_label_orig"))
})

cbx <- codebook_create(sample_data, TRUE, TRUE, TRUE)
test_that("codebook_create(df, freq=TRUE)", {
  expect_equal(cbx$rel_freq[2:3], c(1,1))
})

cbs <- codebook_create(directory=file.path(tempdir(), "test"), TRUE, TRUE, TRUE)

test_that("codebooks_create(directory=file.path(tempdir(), 'test''))", {
  expect_true(all(nrow(cbs), nrow(cbx), nrow(cb)))
})
