#' @title Export to csv file
#'
#' @description Export the survey to csv in a way that declared variables
#' have numeric and character representation in the exported file.
#' @param df A survey dataset.
#' @param file A file name.
#' @importFrom utils write.csv
#' @importFrom dplyr mutate select
#' @export
#' @return The df with declared variables mutated into two columns.
#' @examples
#' sample_data <- read_sav_gesis(
#'   file = system.file("extdata", "ZA5933_sample.sav",
#'                      package = "eurobarometer"))
#' write_csv(sample_data, file = file.path(tempdir(), "sample.csv"))
#' read.csv(file = file.path(tempdir(), "sample.csv"))

write_csv <- function(df, file = NULL) {

  if (is.null(file)) {
    file_name <- file.path(tempdir(), paste0(paste(sample(letters, 12), collapse ="")
                                             , ".csv"))
  } else {
      file_name = file
  }

  declared_vars <- vapply(df, declared::is.declared, logical(1))
  declared_vars <- names(declared_vars[declared_vars])

  message("Writing: ", file_name)

  df <- df %>%
    mutate( across(declared::is.declared, ~as.numeric(.x),   .names = "{col}_num")) %>%
    mutate( across(declared::is.declared, ~as.character(.x), .names = "{col}_chr")) %>%
    select ( -any_of(declared_vars)) %>%
    write.csv( file = file_name, row.names = FALSE)
}


