#' @title Create a codebook for a survey or a survey variable
#'
#' @description Create a codebook table for a variable or several variables.
#' @details Use \code{var_code_table} for a single variable and \code{codebook_create}
#' for a dataset.\cr
#' Use \code{codebook_create(df, ...)} for a survey dataset (or data.frame)\cr
#' Use \code{codebook_create(df, directory='my_directory')} for
#' multiple surveys in a file directory.\cr
#' @param df A survey dataset.
#' @param var_labels Should the variable labels be included in the codebook?
#' Defaults to \code{TRUE}.
#' @param val_labels Should the value labels be included in the codebook?
#' Defaults to \code{TRUE}.
#' @param freq Should a label frequency table be included in the codebook?
#' Defaults to \code{FALSE.}
#' @param directory For multiple surveys, use \code{codebook_create(directory)}
#' with placing the survey files into \code{directory}. Defaults to \code{NULL}
#' (single data.frame case.)
#' @return A dataset (data frame) containing the original survey identifier,
#' the variable names, the variable and value labels, and further metadata among
#' the dataset attributes.
#' @importFrom purrr reduce
#' @importFrom declared is.declared
#' @importFrom dplyr left_join
#' @importFrom dataset dataset related_item
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
                            freq = FALSE,
                            directory = NULL) {

  if(!is.null(directory)) {
    #codebooks_create() is not exported. See source file below codebook_create()
    return(codebooks_create(directory))
  }

  codebooks <- lapply(names(df), function(x) var_code_table(df, x, var_labels=var_labels, val_labels=val_labels, freq=freq))
  assertthat::assert_that(length(codebooks)==length(names(df)))
  codebook <- purrr::reduce(codebooks, rbind)
  survey_title <- dataset::dataset_title(df)[[1]][1]
  survey_title <- ifelse (is.null(survey_title), "Unknown Survey", survey_title)

  return_ds <- dataset::dataset(codebook,
                   Attributes =  names(codebook)[which(! names(codebook) %in% c("freq", "rel_freq"))],
                   Measures =  names(codebook)[which(names(codebook) %in% c("freq", "rel_freq"))],
                   Title = paste0("Codebook for ", survey_title),
                   Identifier = codebook$survey[1])


  if (!is.null(attr(df, "RelatedIdentifier"))) {
    attr(return_ds, "RelatedIdentifier") <- attr(df, "RelatedIdentifier")
  }

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

  if(!is.null(attr(df, "RelatedIdentifier"))) {
    relitem <- attr(df, "RelatedIdentifier")
    names(relitem)
    relitem_col <- as.character (relitem$Identifier)
    names(relitem_col) <- relitem$relatedIdentifierType
  } else {
    relitem_col <- NA_character_
  }

  if (!var_name %in% names(df)) {
    stop("var_code_table(df, var_name): '",
         var_name, "' is not among names(df).")
  }

  var_label = ifelse(is.null(attr(df[[var_name]], "label")),
                     yes = NA_character_,
                     no = attr(df[[var_name]], "label"))

  if(var_labels & ! val_labels) {
    return_df <- data.frame ( survey = as.character(unlist(identifier)),
                              relitem = relitem_col,
                              var_name_orig = var_name,
                              var_label_orig = as.character(var_label))
    row.names(return_df) <- 1:nrow(return_df)
    if(is.na(return_df$relitem)) {
      return(return_df[ , -2])
    }
    names(return_df)[2] <- names(relitem_col)
    return(return_df)
  }

  if ( var_labels & val_labels ) {
    if(declared::is.declared(df[[var_name]])){
      ## var is of type 'declared'
      var_labelling <- labels(df[[var_name]])
      df_rows <- length(var_labelling)
      return_df <- data.frame(
        survey = rep(as.character(unlist(identifier)), df_rows),
        relitem = rep(as.character(relitem_col), df_rows),
        var_name_orig = rep(var_name, df_rows),
        var_label_orig =  rep(attr(df[[var_name]], "label"), df_rows),
        val_code_orig = as.integer(labels(df[[var_name]])),
        val_label_orig = names(labels(df[[var_name]]))
      )

      row.names(return_df) <- 1:nrow(return_df)
      if(is.na(return_df$relitem[1])) {
        return(return_df[ , -2])
      }
      names(return_df)[2] <- names(relitem_col)
      return_df
    } else {
      ## var is not of type 'declared'
      return_df <- data.frame(
        survey = as.character(unlist(identifier)),
        relitem = as.character(relitem_col),
        var_name_orig = var_name,
        var_label_orig =  var_label,
        val_code_orig = NA_integer_,
        val_label_orig = NA_character_
      )

      row.names(return_df) <- 1
      if(is.na(return_df$relitem[1])) {
        return(return_df[ , -2])
      }
      names(return_df)[2] <- names(relitem_col)
      return_df
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

#' @rdname codebook_create
#' @keywords internal
codebooks_create <- function( directory,
                              var_labels = TRUE,
                              val_labels = TRUE,
                              freq = FALSE) {

  spss_files <- dir_spss_files(directory)
  spss_files

  read_spss_codebook <- function(x,
                                 var_labels = TRUE,
                                 val_labels = TRUE,
                                 freq = FALSE) {
    message("Reading ", fs::path_file(x))
    read_codebook <- read_sav_gesis(file = x)
    codebook_create (df = read_codebook, var_labels, val_labels, freq)
  }

  codebook_list <- lapply(spss_files, function(x) read_spss_codebook(x,
                                                                     var_labels = TRUE,
                                                                     val_labels = TRUE,
                                                                     freq = FALSE))

  assertthat::assert_that(length(codebook_list)==length(spss_files))
  new_title <- "Codebook for Multiple Surveys"

  description <- paste0("Survey Codebook Created by retroharmonize from ",
                        paste(vapply( codebook_list, function(x) unique(x$survey), character(1)), collapse = "; ")
  )
  relitems <- purrr::reduce(lapply(codebook_list, function(x) attr(x, "RelatedIdentifier")), rbind)
  multiple_codebooks <-purrr::reduce(codebook_list, rbind)

  return_ds <- dataset::dataset(x = multiple_codebooks, Title = new_title )
  dataset::description(return_ds) <- description
  attr(return_ds, "RelatedIdentifier") <- relitems

  return_ds
}

#' @keywords internal
dir_spss_files <- function( directory ) {

  assertthat::assert_that(
    fs::dir_exists(directory),
    msg = paste0("dir_spss_files(directory): ", directory, " is not an existing directory")
  )

  dir_files <- fs::path_file(dir(directory))

  spss_files <- fs::path ( directory,  dir(directory)[fs::path_ext(dir(directory)) %in% c("sav", "spss")])

  if (length(spss_files)<1) {
    warning("dir_spss_files(,", directory, "): no .sav or .spss files here.")
  }

  spss_files
}
