sample_data <- read_sav_gesis(
  file = system.file("extdata", "ZA5933_sample.sav",
                     package = "eurobarometer"))

demography_schema <- get_demography_schema()
demography_schema

df <- sample_data[, names(sample_data) %in% demography_schema$var_name_orig]
classes <- c(uri = "character", d11 = "numeric", d25 = "declared", d7 = "declared", d8 = "declared")

classes_test <- vapply( as_class_target(df, demography_schema),
                   function(x) class(x)[1], character(1))

test_that("multiplication works", {
  expect_true(all(classes == classes_test))
})

