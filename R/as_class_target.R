#' @title Convert variable classes according to a crosswalk schema
#'
#' @description A modified as.factor() method that retains the variable label,
#' if it exists.
#' @param df A dataset containing a survey.
#' @param crosswalk_schema A crosswalk schema (table).#'
#' @return A survey dataset with the variables converted according to the
#' \code{class_target} column of the crosswalk schema.
#' @importFrom declared as.declared
#' @importFrom dplyr mutate
#' @examples
#' sample_data <- read_sav_gesis(
#'   file = system.file("extdata", "ZA5933_sample.sav",
#'                      package = "eurobarometer"))
#'
#' demography_schema <- get_demography_schema()
#'
#' df <- sample_data[, names(sample_data) %in% demography_schema$var_name_orig]
#' as_class_target(df, demography_schema)
#' @export

as_class_target <- function(df, crosswalk_schema ) {

  df %>%
    select( any_of( crosswalk_schema$var_name_orig )) %>%
    mutate ( across
             (crosswalk_schema$var_name_orig[which(crosswalk_schema$class_target == "numeric")], as_numeric)
    ) %>%
    mutate ( across
             (crosswalk_schema$var_name_orig[which(crosswalk_schema$class_target == "character")], as.character)
    ) %>%
    mutate ( across
             (crosswalk_schema$var_name_orig[which(crosswalk_schema$class_target == "factor")], as.factor)
    )
}



