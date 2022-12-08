## code to prepare `ZA5933_sample` dataset goes here

ZA5933 <- haven::read_sav(file = here("not_included", "ZA5933_v6-0-0.sav"))
names(ZA5933)
library(dplyr)
set.seed(1234)
ZA5933_sample <-ZA5933 %>%
  select ( any_of(c("studyno1", "studyno2", "doi", "edition", "survey", "caseid",
                    "uniqid", "tnscntry", "country", "isocntry", "w1", "wex", "eu15",
                    "qb1_1", "qb1_2", "qb1_3", "qb1_4", "qb2", "qb3",
                    "d7", "d8", "d25", "d60", "p1", "nuts", "nation"))) %>%
  sample_n(200)

haven::write_sav(ZA5933_sample, here("inst", "extdata", "ZA5933_sample.sav"))


