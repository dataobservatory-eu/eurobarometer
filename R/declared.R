#' The declared class
#'
#' See \code{declared::\link[declared:declared]{declared}} for details.
#'
#' @name declared
#' @export
#' @param x A numeric vector to label, or a declared labelled vector (for undeclare)
#' @param labels A named vector or NULL. The vector should be the same type as x. Unlike factors, labels don't need to be exhaustive: only a fraction of the values might be labelled
#' @param na_values A vector of values that should also be considered as missing
#' @param na_range A numeric vector of length two giving the (inclusive) extents of the range. Use -Inf and Inf if you want the range to be open ended
#' @param label A short, human-readable description of the vector
#' @param measurement Optional, user specified measurement level
#' @param llevels Logical, when x is a factor only use those levels that have labels
#' @param ... Other arguments used by various other methods
#' @importFrom declared declared
#' @examples
#' x <- declared(
#'   c(1:5, -1),
#'   labels = c(Good = 1, Bad = 5, DK = -1),
#'   na_values = -1
#' )
#' @return The result of calling `rhs(lhs)`.
NULL
