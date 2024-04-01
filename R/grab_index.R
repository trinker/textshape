#' Get Elements Matching Between 2 Points
#'
#' Use regexes to get all the elements between two points.
#'
#' @param x A character vector, \code{\link[base]{data.frame}}, or list.
#' @param from An integer to start from (if \code{NULL} defaults to the first
#' element/row).
#' @param to A integer to get up to (if \code{NULL} defaults to the last
#' element/row).
#' @param \ldots ignored.
#' @return Returns a subset of the original data set.
#' @export
#' @examples
#' grab_index(DATA, from = 2, to = 4)
#' grab_index(DATA$state, from = 2, to = 4)
#' grab_index(DATA$state, from = 2)
#' grab_index(DATA$state, to = 4)
#' grab_index(matrix(1:100, nrow = 10), 2, 4)
grab_index <- function(x, from = NULL, to = NULL, ...){

    UseMethod('grab_index')

}

#' @export
#' @rdname grab_index
#' @method grab_index character
grab_index.character <- function(x, from = NULL, to = NULL, ...){

    grab_index.default(x, from = from, to = to, ...)

}

#' @export
#' @rdname grab_index
#' @method grab_index default
grab_index.default <- function(x, from = NULL, to = NULL, ...){

    if (is.null(from)) from  <- 1
    if (is.null(to)) to <- length(x)

    if (from < 1 | from > length(x)) stop('`from` must be > 1 & < length(x)')
    if (to < 1 | to > length(x)) stop('`to` must be > 1 & < length(x)')
    x[from:to]

}

#' @export
#' @rdname grab_index
#' @method grab_index list
grab_index.list <- function(x, from = NULL, to = NULL, ...){

    grab_index.default(x, from = from, to = to, ...)

}

#' @export
#' @rdname grab_index
#' @method grab_index data.frame
grab_index.data.frame <- function(x, from = NULL, to = NULL, ...){

    if (from < 1 | from > length(x)) stop('`from` must be > 1 & < length(x)')
    if (to < 1 | to > length(x)) stop('`to` must be > 1 & < length(x)')
    x[from:to,, drop =FALSE]

}


## Helper function(s)
#' @export
#' @rdname grab_index
#' @method grab_index matrix
grab_index.matrix <- function(x, from = NULL, to = NULL, ...){

    if (from < 1 | from > length(x)) stop('`from` must be > 1 & < length(x)')
    if (to < 1 | to > length(x)) stop('`to` must be > 1 & < length(x)')
    x[from:to,, drop =FALSE]

}

