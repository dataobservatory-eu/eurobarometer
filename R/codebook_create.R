#' @title Create a codebook for a survey or a survey variable
#'
#' @description Create a codebook table for a variable or several variables.
#' @details Use \code{var_code_table} for a single variable and \code{codebook_create}
#' for a dataset.
#' @param df A survey dataset.
#' @return A data frame containing the original survey identifier,
#' the variable names, the variable and value labels.
#' @importFrom purrr reduce
#' @importFrom declared is.declared
#' @examples
#' sample_data <- read_sav_gesis(
#' file = system.file("extdata", "ZA5933_sample.sav",
#'                    package = "eurobarometer"))
#'
#' var_code_table(sample_data, "d7")
#' codebook_create(sample_data[, c("d25", "d60")])
#' @export

codebook_create <- function(df) {
  codebooks <- lapply(names(df), function(x) var_code_table(df, x))
  purrr::reduce(codebooks, rbind)
}


#' @rdname codebook_create
#' @param df A survey dataset
#' @param var_name A variable name in df
#' @importFrom dataset identifier
#' @export

var_code_table <- function(df, var_name) {

  identifier <- dataset::identifier(df)

  if (is.null(identifier)) {
    identifier = list (doi = "unknonw", gesis_study_no = "unknown")
  }

  if (!var_name %in% names(df)) {
    stop("var_code_table(df, var_name): '",
         var_name, "' is not among names(df).")
  }

  if(declared::is.declared(df[[var_name]])){
    ## var is of type 'declared'
    var_labelling <- labels(df[[var_name]])
    df_rows <- length(var_labelling)
    data.frame(
      survey = rep(as.character(unlist(identifier)), df_rows),
      var_name_orig = rep(var_name, df_rows),
      var_label_orig =  rep(attr(df[[var_name]], "label"), df_rows),
      val_code_orig = as.integer(labels(df[[var_name]])),
      val_label_orig = names(labels(df[[var_name]]))
    )
  } else {
    ## var is not of type 'declared'
    var_label = ifelse(is.null(attr(df[[var_name]], "label")),
                       yes = NA_character_, no = attr(df[[var_name]], "label"))
    data.frame(
      survey = as.character(unlist(identifier)),
      var_name_orig = var_name,
      var_label_orig =  var_label,
      val_code_orig = NA_integer_,
      val_label_orig = NA_character_
    )
  }
}



