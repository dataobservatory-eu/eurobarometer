
library(dplyr)
eurobarometer_basic_codebook <- data.frame(
  Title = c("Eurobarometer 67.1 (Feb-Mar 2007)"),
  ZACAT = c("ZA4529"),
  var_name_orig = c("v5"),
  var_label_orig = c("ID SERIAL NUMBER"),
  var_name_target = "uniqid",
  var_label_target = NA_character_,
  zacat_doi = c("10.4232/1.10983")
  )

eurobarometer_basic_codebook <- eurobarometer_basic_codebook %>%
  mutate ( var_label_target = case_when(
    .data$var_name_target == "uniqid" ~ paste0("GESIS UNIQUE ID ", "[", .data$var_label_orig, "]"),
    TRUE ~ .data$var_label_orig
  ))


usethis::use_data(eurobarometer_basic_codebook, overwrite = TRUE)
