#' @title Create a codebook for a survey or a survey variable
#'
#' @description Create a codebook table for a variable or several variables.
#' @details Use \code{var_code_table} for a single variable and \code{codebook_create}
#' for a dataset.
#' @param df A survey dataset.
#' @param var_labels Should the variable labels be included in the codebook?
#' Defaults to \code{TRUE}.
#' @param val_labels Should the value labels be included in the codebook?
#' Defaults to \code{TRUE}.
#' @param freq Should a label frequency table be included in the codebook?
#' Defaults to \code{FALSE.}
#' @return A dataset (data frame) containing the original survey identifier,
#' the variable names, the variable and value labels.
#' @importFrom purrr reduce
#' @importFrom declared is.declared
#' @examples
#' sample_data <- read_sav_gesis(
#' file = system.file("extdata", "ZA5933_sample.sav",
#'                    package = "eurobarometer"))
#'
#' var_code_table(sample_data, "d7")
#' codebook_create(sample_data[, c("d25", "d60")], freq=TRUE)
#' @export

codebook_create <- function(df,
                            var_labels = TRUE,
                            val_labels = TRUE,
                            freq = FALSE) {
  codebooks <- lapply(names(df), function(x) var_code_table(df, x, var_labels=var_labels, val_labels=val_labels, freq=freq))
  codebook <- purrr::reduce(codebooks, rbind)
  survey_title <- dataset::dataset_title(df)[[1]][1]
  survey_title <- ifelse (is.null(survey_title), "Unknown Survey", survey_title)

  return_ds <- dataset::dataset(codebook,
                   Attributes =  names(codebook)[which(! names(codebook) %in% c("freq", "rel_freq"))],
                   Measures =  names(codebook)[which(names(codebook) %in% c("freq", "rel_freq"))],
                   Title = paste0("Codebook for ", survey_title),
                   Identifier = codebook$survey[1])

  relitem <- dataset::related_item(Identifier = codebook$survey[1],
                        relatedIdentifierType = "DOI", relationType = "IsDerivedFrom",
                        resourceTypeGeneral = "Dataset")
  attr(return_ds, "RelatedIdentifier") <- relitem

  return_ds
}


#' @rdname codebook_create
#' @param df A survey dataset
#' @param var_name A variable name in df
#' @importFrom dataset identifier
#' @export

var_code_table <- function(df,
                           var_name,
                           var_labels = TRUE,
                           val_labels = TRUE,
                           freq = FALSE) {

  identifier <- dataset::identifier(df)

  if (is.null(identifier)) {
    identifier = list (doi = "unknonw", gesis_study_no = "unknown")
  }

  if (!var_name %in% names(df)) {
    stop("var_code_table(df, var_name): '",
         var_name, "' is not among names(df).")
  }

  var_label = ifelse(is.null(attr(df[[var_name]], "label")),
                     yes = NA_character_,
                     no = attr(df[[var_name]], "label"))

  if(var_labels & ! val_labels) {
    return_df <- data.frame ( var_name_orig = var_name,
                              var_label_orig = as.character(var_label))
    return(return_df)
  }

  if ( var_labels & val_labels ) {
    if(declared::is.declared(df[[var_name]])){
      ## var is of type 'declared'
      var_labelling <- labels(df[[var_name]])
      df_rows <- length(var_labelling)
      return_df <- data.frame(
        survey = rep(as.character(unlist(identifier)), df_rows),
        var_name_orig = rep(var_name, df_rows),
        var_label_orig =  rep(attr(df[[var_name]], "label"), df_rows),
        val_code_orig = as.integer(labels(df[[var_name]])),
        val_label_orig = names(labels(df[[var_name]]))
      )
    } else {
      ## var is not of type 'declared'
      return_df <- data.frame(
        survey = as.character(unlist(identifier)),
        var_name_orig = var_name,
        var_label_orig =  var_label,
        val_code_orig = NA_integer_,
        val_label_orig = NA_character_
      )
    }
  }

  if (freq) {
    var_freq_table <- create_freq_table(df[[var_name]])
    dplyr::left_join (return_df, var_freq_table, by = 'val_label_orig')
  } else {return_df}
}

#' @keywords internal
create_freq_table <- function(x) {
  factor_var <- as.factor(declared::undeclare(x))
  freq_table <- data.frame(
    val_label_orig = names(summary(factor_var)),
    freq = as.numeric(summary(factor_var))
  )
  freq_table$rel_freq <- freq_table$freq / sum(freq_table$freq)
  if ( ! length(x) == sum(freq_table$freq) ) {
    stop ("create_freq_table(x): frequencies and length(x) do not match.")
  }
  freq_table
}
