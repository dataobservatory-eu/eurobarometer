devtools::load_all()
gesis_dir <- "/home/antaldaniel/Documents/_data/GESIS"
library(dplyr)
ZA5933 <- read_sav_gesis(file = file.path(gesis_dir, "ZA5933_v6-0-0.sav"))
ZA5688 <- read_sav_gesis(file = file.path(gesis_dir, "ZA5688_v6-0-0.sav"))

dataset::identifier(ZA5688)

cb <- ZA5688 %>%
  select ( any_of(get_demography_schema()$var_name_orig
)) %>%
  codebook_create()


attributes(ZA5688)

which(declared::is.declared())

iris %>%
  group_by(Species) %>%
  mutate(across(contains(".Width"), ~.x - mean(.x), .names = "residual_{col}")) %>%
  mutate(across())

library(purrr)

mtcars %>% mutate("{var_name}" := 235 / mpg)

ZA5933_declared$caseid
ZA5933_declared$uniqid
ZA5933_declared$tnscntry
ZA5933_declared$country
ZA5933_declared$isocntry
ZA5933_declared$w1
ZA5933_declared$wextra
ZA5933_declared$qb2

ZA5933_declared$d11

ZA5933_declared$d60
ZA5933_declared$d25
ZA5933_declared$d8
ZA5933_declared$d70
ZA5933_declared$d15a
ZA5933_declared$d15b
ZA5933_declared$p1
ZA5933_declared$d7

eb_identification <- tibble::tribble(
  ~var_name_orig, ~var_name_target, ~class_target,
  "caseid", "caseid", "character",
  "uniqid", "uniqid", "character",
  "w1", "w1", "numeric",
  "wextra", "wex", "numeric",
  "isocntry", "isocntry", "character"
)

eb_identification$var_name_orig

lubridate::dmy("29th November 2014")

labelled::var_label(ZA5933_declared$p1)

conversion_table <- a
names(labelled::val_labels(ZA5933_declared$p1))
as.numeric(labelled::val_labels(ZA5933_declared$p1))


df <- ZA5933_declared


identification <- ZA5933_declared %>%
  select( any_of( eb_identification$var_name_orig )) %>%
  mutate ( across
           (eb_identification$var_name_orig[which(eb_identification$class_target == "numeric")], as.numeric)
           ) %>%
  mutate ( across
           (eb_identification$var_name_orig[which(eb_identification$class_target == "character")], as.character)
  ) %>%
  mutate ( across
           (eb_identification$var_name_orig[which(eb_identification$class_target == "factor")], as.factor)
  ) %>%
  mutate( id  = paste0(tolower("ZA5933_"), .data$uniqid)) %>%
  relocate( id, .before = everything())

names(identification) <- c("id", eb_identification$var_name_target)




unique(ZA5933_declared$caseid)

unique(ZA5933_declared$caseid)
unique(ZA5933_declared$doi)
unique(ZA5933_declared$edition)
unique(ZA5933_declared$version)
unique(ZA5933_declared$survey)

demography_questions <- tibble::tribble(
  ~var_name_orig, ~var_name,
  "d11",  "age_exact",
  "d25",  "eb_type_community",
  "d7",   "marital_status",
  "d8",   "age_education",
  "d15a", "occupation",
  "d15b", "occupation_last"
)

eb_trend_questions <- tibble::tribble(
  ~var_name_orig, ~var_name,
  "d60", "difficulty_bills",
  "d70",  "life_satisfaction"
)


eb_protocol <- tibble::tribble(
  ~var_name_orig, ~var_name,
  "p1", "date_interview"
)
