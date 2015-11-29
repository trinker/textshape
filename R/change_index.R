#' Indexing of Changes in Runs
#'
#' Find the indices of changes in runs in a vector.  This function pairs well with
#' \code{split_index} and is the default for the \code{indices} in all \code{split_index}
#' functions that act on atomic vectors.
#'
#' @param x A vector.
#' @return Returns a vector of integer indices of where a vector initially changes.
#' @export
#' @seealso \code{\link[textshape]{split_index}}
#' @examples
#' set.seed(10)
#' (x <- sample(0:1, 20, TRUE))
#' change_index(x)
#' split_index(x, change_index(x))
#'
#'
#' (p_chng <- change_index(CO2[["Plant"]]))
#' split_index(CO2[["Plant"]], p_chng)
change_index <- function (x) {
    head(1 + cumsum(rle(as.character(x))[[1]]), -1)
}

