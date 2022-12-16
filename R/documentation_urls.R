#' @title Get ZACAT Data URL
#' @description Get the URL of the data description on GESIS.
#' @param ZACAT A ZACAT ID.
#' @examples get_zacat_data_url("ZA4599")
#' @family documentation
#' @export

get_zacat_data_url <- function(ZACAT) {
 paste0('https://search.gesis.org/research_data/', ZACAT)
}
