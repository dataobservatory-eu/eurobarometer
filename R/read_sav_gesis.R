#' @title Read a GESIS .sav File
#'
#' @description A wrapper around \code{\link[haven:read_sav]{read_sav}}.
#'
#' @param file See \code{\link[haven:read_sav]{read_sav}}.
#' @param gesis_study_id The GESIS study number in ZA5933 format.
#' @importFrom haven read_sav
#' @importFrom purrr map_df
#' @importFrom declared as.declared
#' @importFrom dataset dublincore_add
#' @export
#' @examples
#' \donttest{
#' read_sav_gesis(file = file.path(gesis_dir, "ZA5933_v6-0-0.sav"))
#' }
#'

read_sav_gesis <- function (file) {
  gesis_sav <- haven::read_sav(file)
  gesis_sav_declared <- purrr::map_df(gesis_sav, declared::as.declared )
  gesis_study_no <- get_gesis_study_id(gesis_sav_declared)
  df <- id_add(gesis_sav_declared, gesis_study_id=gesis_study_no)

  potential_attributes <- c("studyno1", "studyno2", "studyno", "doi", "edition", "survey")
  potential_dimensions <- c("isocntry", "tnscountry","tnscntry", "country")

  attrbs <- potential_attributes[which(potential_attributes %in% names(df))]
  dimns <- potential_dimensions[which(potential_dimensions %in% names(gesis_sav_declared ))]
  msrs <- names(gesis_sav_declared)[! names(gesis_sav_declared) %in% c(attrbs, dimns)]

  ds <- dataset::dublincore_add(x = df,
                                Title = get_gesis_survey_name(gesis_sav_declared),
                                Publisher = "GESIS",
                                Identifier = get_gesis_doi(gesis_sav_declared))

  ds
}

#' Internal functions below --------------------------------------------


#' @keywords internal
get_gesis_study_id <- function(x) {
  if ("doi" %in% names(x)) {
    paste0("ZA", as.character(as.numeric(unique(x$studyno1))))
  } else {
    "unknown"
  }
}

#' @keywords internal
get_gesis_doi <- function(x) {
  if ("studyno1" %in% names(x)) {
    unique(x$doi)
  } else {
    "unknown"
  }
}

#' @keywords internal
get_gesis_survey_name <- function(x){
  if ("survey" %in% names(x)) {
    as.character(unique(x$survey))
  } else {
    "Unknown"
  }
}
