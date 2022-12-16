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
#' @importFrom fs path_file
#' @importFrom DDIwR convert
#' @export
#' @examples
#' \donttest{
#' read_sav_gesis(file = file.path(gesis_dir, "ZA5933_v6-0-0.sav"))
#' }
#'

read_sav_gesis <- function (file, id_var = NULL) {
  # gesis_sav_declared <- DDIwR::convert(file)
  gesis_sav <- haven::read_sav(file)
  gesis_sav_declared <- as.data.frame(lapply(gesis_sav, declared::as.declared))
  zacat_id <- get_gesis_survey_id(file)

  sid_var <- survey_unique_id_var_name(df = gesis_sav_declared, file, id_var=NULL)

  gesis_sav_declared$uri <- as.character(gesis_sav_declared[, which(names(gesis_sav_declared)== sid_var)])
  gesis_sav_declared$uri <- paste0(zacat_id, "_", gesis_sav_declared$uri)

  gesis_sav_declared <- cbind (gesis_sav_declared[, ncol(gesis_sav_declared)], gesis_sav_declared[,1:ncol(gesis_sav_declared)-1])

  names(gesis_sav_declared)[1] <- "uri"
  attr(gesis_sav_declared$uri, "label") <- "UNIQUE ID BY RETROHARMONIZE"

  potential_attributes <- c("studyno1", "studyno2", "studyno", "doi", "edition", "survey")
  potential_dimensions <- c("isocntry", "tnscountry","tnscntry", "country")

  #attrbs <- potential_attributes[which(potential_attributes %in% names(df))]
  #dimns <- potential_dimensions[which(potential_dimensions %in% names(gesis_sav_declared ))]
  #msrs <- names(gesis_sav_declared)[! names(gesis_sav_declared) %in% c(attrbs, dimns)]

  doi <- get_gesis_doi(gesis_sav_declared, zacat_id)
  title <- get_gesis_survey_name(gesis_sav_declared, zacat_id)


  ds <- dataset::dataset(gesis_sav_declared,
                         Title = title,
                         Attributes = potential_attributes[potential_attributes %in% names(df)],
                         Publisher = "GESIS",
                         Identifier = list ( doi = doi))
  relitem <- dataset::related_item(Identifier = get_gesis_survey_id(file),  relatedIdentifierType = "ZACAT", relationType = "IsDerivedFrom", resourceTypeGeneral = "Dataset")

  attr(ds, "RelatedIdentifier") <- relitem

  attr(ds, "Source") <- fs::path_file(file)

 # ds <- dataset::datacite_add(ds,
 #                               Title = get_gesis_survey_name(gesis_sav_declared),
 #                               Creator = "GESIS",
 #                              RelatedIdentifier = list ( gesis_study_no = gesis_study_no))

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
get_gesis_doi <- function(x, zacat_id=NULL) {
  if ("studyno1" %in% names(x)) {
    unique(x$doi)
  } else if (!is.null(zacat_id)) {
    row_number <- which(zacat_id %in% eurobarometer_basic_codebook$ZACAT)
    ifelse(length(row_number)==1,
           yes = eurobarometer_basic_codebook$zacat_doi[row_number],
           no = "unknown")
    } else {
    "unknown"
  }
}

#' @keywords internal
get_gesis_survey_name <- function(x, zacat_id=NULL){
  if ("survey" %in% names(x)) {
    as.character(unique(x$survey))
  } else if (!is.null(zacat_id)) {
    row_number <- which(zacat_id %in% eurobarometer_basic_codebook$ZACAT)
    ifelse(length(row_number)==1,
           yes = eurobarometer_basic_codebook$Title[row_number],
           no = "unknown")
  } else {
    "unknown"
  }
}

#' @importFrom fs path_file
#' @keywords internal
get_gesis_survey_id <- function(file) {
  substr(fs::path_file(file), 1,6)
}

#' @keywords internal
survey_unique_id_var_name <- function(df, file, id_var) {

  if( !is.null(id_var)) {

    if (! id_var %in% names(df) ) {
      stop("survey_unique_name(df, ..., id_var): id_var='", id_var, "' is is not a name in df.")
    }
    id_var
  } else if (get_gesis_survey_id(file) %in% eurobarometer_basic_codebook$ZACAT ) {

    row_num <- which(get_gesis_survey_id(file) == eurobarometer_basic_codebook$ZACAT)
    eurobarometer_basic_codebook$var_name_orig[row_num]
  } else if ("uniqid" %in% names(df)) {
    "uniqid"
  } else {
    "unknown"
  }
}

