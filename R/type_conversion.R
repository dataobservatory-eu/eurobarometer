#' @title Coerce to numeric
#'
#' @description A modified as.numeric() method that retains the variable label,
#' if it exists.
#' @param x A numeric vector
#' @return A declared or labelled variable as numeric.
#' @export
#' @examples
#' x <- declared(
#'  c(1:5, -1),
#'  labels = c(Good = 1, Bad = 5, DK = -1),
#'  na_values = -1
#' )
#' attr(x, "label") <- "Example"
#' as_numeric(x)

as_numeric <- function (x) {


  var_label <- attr(x, "label")
  y <- as.numeric(x)

  if(!is.null(var_label)) {
    attr(y, "label") <- var_label
  }

  y
}

#' @title Coerce to character
#'
#' @description A modified as.character() method that retains the variable label,
#' if it exists.
#' @param x A character vector
#' @return A declared or labelled variable as character.
#' @export
#' @examples
#' x <- declared(
#'  c(1:5, -1),
#'  labels = c(Good = 1, Bad = 5, DK = -1),
#'  na_values = -1
#' )
#' attr(x, "label") <- "Example"
#' as_character(x)

as_character <- function (x) {


  var_label <- attr(x, "label")
  y <- as.character(x)

  if(!is.null(var_label)) {
    attr(y, "label") <- var_label
  }

  y
}

#' @title Coerce to factor
#'
#' @description A modified as.factor() method that retains the variable label,
#' if it exists.
#' @param x A factor vector
#' @return A declared or labelled variable as factor.
#' @export
#' @examples
#' x <- declared(
#'  c(1:5, -1),
#'  labels = c(Good = 1, Bad = 5, DK = -1),
#'  na_values = -1
#' )
#' attr(x, "label") <- "Example"
#' as_factor(x)

as_factor <- function (x) {
  var_label <- attr(x, "label")
  y <- as.factor(x)

  if(!is.null(var_label)) {
    attr(y, "label") <- var_label
  }

  y
}
