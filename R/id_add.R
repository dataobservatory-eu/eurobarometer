#' @title Add a unique identifier
#'
#' @description Add a unique identifier to a GESIS survey, which remains identical
#' across several surveys.
#' @param df A dataset.
#' @param gesis_study_id The GESIS study number in ZA5933 format.
#' @importFrom tibble tribble
#' @importFrom dplyr relocate mutate
#' @examples
#' df1 <- data.frame(
#'          uniqid = c(1001,1002,1003),
#'          caseid = c(2001,2002,2003),
#'          isocntry = c("BE", "BE", "NL")
#'          )
#'
#' id_add(df1, "ZA001")
#' @export

id_add <- function(df, gesis_study_id, id_crosswalk_table = NULL) {

  if (is.null(id_crosswalk_table)) {
    id_crosswalk_table <- id_crosswalk_schema()
  }

  identification <- df %>%
    mutate ( across
             (id_crosswalk_table$var_name_orig[which(id_crosswalk_table$class_target == "numeric")], as.numeric)
    ) %>%
    mutate ( across
             (id_crosswalk_table$var_name_orig[which(id_crosswalk_table$class_target == "character")], as.character)
    ) %>%
    mutate ( across
             (id_crosswalk_table$var_name_orig[which(id_crosswalk_table$class_target == "factor")], as.factor)
    ) %>%
    mutate( id  = paste0(tolower(gesis_study_id), "_", .data$uniqid)) %>%
    relocate( id, .before = everything())

  names(identification) <- c("id", names(df))

  identification

}

#' @title Create a crosswalk schema for the unique identifier
#' @importFrom tibble tribble

id_crosswalk_schema <- function() {

  tibble::tribble(
    ~var_name_orig, ~var_name_target, ~class_target,
    "caseid", "caseid", "character",
    "uniqid", "uniqid", "character",
  )

}
