#' Split Data Forms at Specified Indices
#'
#' Split data forms at specified integer indices.
#'
#' @param x A data form (\code{list}, \code{vector}, \code{data.frame},
#' \code{matrix}).
#' @param indices A vector of integer indices to split at.  If \code{indices}
#' contains the index 1, it will be silently dropped.  The default value when
#' \code{x} evaluates to \code{TRUE} for \code{\link[base]{is.atomic}} is to use
#' \code{\link[textshape]{change_index}(x)}.
#' @param names Optional vector of names to give to the list elements.
#' @param \ldots Ignored.
#' @return Returns of list of data forms broken at the \code{indices}.
#' @note Two dimensional object will retain dimension (i.e., \code{drop = FALSE}
#' is used).
#' @seealso \code{\link[textshape]{change_index}}
#' @export
#' @examples
#' ## character
#' split_index(LETTERS, c(4, 10, 16))
#' split_index(LETTERS, c(4, 10, 16), c("dog", "cat", "chicken", "rabbit"))
#'
#' ## numeric
#' split_index(1:100, c(33, 66))
#'
#' ## factor
#' (p_chng <- change_index(CO2[["Plant"]]))
#' split_index(CO2[["Plant"]], p_chng)
#' #`change_index` was unnecessary as it is the default of atomic vectors
#' split_index(CO2[["Plant"]])
#'
#' ## list
#' split_index(as.list(LETTERS), c(4, 10, 16))
#'
#' ## data.frame
#' (vs_change <- change_index(mtcars[["vs"]]))
#' split_index(mtcars, vs_change)
#'
#' ## matrix
#' (mat <- matrix(1:50, nrow=10))
#' split_index(mat, c(3, 6, 10))
split_index <- function(x, 
    indices = if (is.atomic(x)) {NULL} else {change_index(x)}, names = NULL, 
    ...) {

    indices
    names
    UseMethod("split_index")

}

#' @export
#' @method split_index list
#' @rdname split_index
split_index.list <- function(x, indices, names = NULL, ...) {

    names <- name_len_check(indices, names)
    out <- split_index_vector(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index data.frame
#' @rdname split_index
split_index.data.frame <- function(x, indices, names = NULL, ...) {

    names <- name_len_check(indices, names)
    out <- split_index_mat(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index matrix
#' @rdname split_index
split_index.matrix <- function(x, indices, names = NULL, ...) {

    names <- name_len_check(indices, names)
    out <- split_index_mat(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index numeric
#' @rdname split_index
split_index.numeric <- function(x, indices = change_index(x), names = NULL, 
    ...) {

    names <- name_len_check(indices, names)
    out <- split_index_vector(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index factor
#' @rdname split_index
split_index.factor <- function(x, indices = change_index(x), names = NULL, 
    ...) {

    names <- name_len_check(indices, names)
    out <- split_index_vector(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index character
#' @rdname split_index
split_index.character <- function(x, indices = change_index(x), 
    names = NULL, ...) {

    names <- name_len_check(indices, names)
    out <- split_index_vector(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}

#' @export
#' @method split_index default
#' @rdname split_index
split_index.default <- function(x, indices = change_index(x), 
    names = NULL, ...) {

    names <- name_len_check(indices, names)
    out <- split_index_vector(x, indices, ...)
    if(!is.null(names)) names(out) <- names
    out
}




split_index_vector <- function(x, indices){
    if (any(indices %in% "1")) indices <- indices[!indices %in% "1"]
    starts <- c(1, indices)
    Map(function(s, e) {x[s:e]}, starts, c(indices - 1, length(x)))
}


split_index_mat <- function(x, indices, names = NULL, ...) {

    indices <- indices[!indices %in% "1"]
    len <- nrow(x)
    if (len < max(indices)) {
        stop(
            "One or more `indices` elements exceeds nrow of `x`",
            call. = FALSE
        )
    }

    starts <- c(1, indices)
    Map(function(s, e) {x[s:e, ,drop=FALSE]}, starts, c(indices - 1, nrow(x)))

}



name_len_check <- function(indices, names) {

    if (is.null(names)) return(names)
    check <- length(indices) + 1 == length(names)
    if(!check) {
        warning(
            paste(
                "length of `names` muse be equal to length", 
                "of `indices` + 1; ignoring `names`", 
            ),
            call. = FALSE
        )
    }
    if (!check) NULL else names
}



