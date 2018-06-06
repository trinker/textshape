#' Extract Only Unique Pairs of Collocating Words in 
#' \code{\link[textshape]{tidy_colo_dtm}}
#'
#' \code{\link[textshape]{tidy_colo_dtm}} utilizes the entire matrix to generate
#' the tidied data.frame.  This means that the upper and lower triangles are
#' used redundantly.  This function eliminates this redundancy by dropping one
#' set of the pairs from a tidied data.frame.
#'
#' @param x A \code{\link[base]{data.frame}} with two columns that contain
#' redundant pairs.
#' @param col1 A string naming column 1.
#' @param col2 A string naming column 2.
#' @param \ldots ignored.
#' @return Returns a filtered \code{\link[base]{data.frame}}.
#' @export
#' @seealso \code{\link[textshape]{tidy_colo_dtm}}
#' @examples
#' dat <- data.frame(
#'     term_1 = LETTERS[1:10],
#'     term_2 = LETTERS[10:1],
#'     stringsAsFactors = FALSE
#' )
#'
#' unique_pairs(dat)
unique_pairs <- function(x, col1 = 'term_1', col2 = 'term_2', ...) {

    UseMethod('unique_pairs')
}

#' @export
#' @rdname unique_pairs
#' @method unique_pairs default
unique_pairs.default <- function(x, col1 = 'term_1', col2 = 'term_2', ...) {

    x[!duplicated(apply(
        data.table::data.table(x[, c(col1, col2)]), 
        1, 
        sorter
    )),]
}

#' @export
#' @rdname unique_pairs
#' @method unique_pairs data.table
unique_pairs.data.table <- function(x, col1 = 'term_1', col2 = 'term_2', ...) {

    x[!duplicated(apply(
        data.table::data.table(x[, c(col1, col2), with = FALSE]), 
        1, 
        sorter
    )),]
}

sorter <- function(x) paste(sort(x), collapse = "")



