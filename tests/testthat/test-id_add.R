
df1 <- data.frame(
  uniqid = c(1001,1002,1003),
  caseid = c(2001,2002,2003),
  isocntry = c("BE", "BE", "NL")
)

test_that("id_crosswalk_schema() internal function", {
  expect_equal(id_crosswalk_schema()$var_name_orig == c("caseid","uniqid"), rep(TRUE, 2))
})

test_that("id_add()", {
  expect_equal(id_add(df1, "ZA001")$id, c("za001_1001", "za001_1002", "za001_1003"))
})
