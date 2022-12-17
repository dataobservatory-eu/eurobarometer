## code to prepare `ZA5933_sample` dataset goes here
library(here)
library(dplyr)
ZA4529 <- haven::read_sav(file = here(gesis_dir, "ZA4529_v3-0-1.sav"))
names(ZA4529)
library(dplyr)
set.seed(1234)
ZA4529_sample <-ZA4529 %>%
  select ( any_of(c("v2", "v3", "v4", "v5", "v6", "v7", "v8", "v47", "v26",
                    "v94","v95", "v96", "v97", "v98", "v99", "v100", "v101",
                    "v102", "v103", "v104", "v105",
                    "v723", "v724", "d727", "v732", "d60", "v755", "v790", "v791",
                    "v792", "v793"))) %>%
  sample_n(200)

haven::write_sav(ZA4529_sample, here("inst", "extdata", "ZA4529_sample.sav"))


