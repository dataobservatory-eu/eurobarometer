#' @title Demography crosswalk schema
#' @importFrom tibble tribble
#' @export
#' @return A data frame with a standard demography crosswalk schema.
#' @examples get_demography_schema()

get_demography_schema <- function(){
  tibble::tribble(
    ~var_name_orig, ~var_name_target, ~class_target,
    "id", "id", "character",
    "d11",  "age_exact", "numeric",
    "d25",  "eb_type_community", "declared",
    "d7",   "marital_status", "declared",
    "d8",   "age_education", "declared",
    "d15a", "occupation", "declared",
    "d15b", "occupation_last", "declared"
  )
}
