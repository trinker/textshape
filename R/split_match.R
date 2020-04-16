#' Split a Vector By Split Points
#'
#' \code{split_match} - Splits a \code{vector} into a list of vectors based on
#' split points.
#'
#' @param x A vector with split points.
#' @param split A vector of places (elements) to split on or a regular
#' expression if \code{regex} argument is \code{TRUE}.
#' @param include An integer of \code{1} (\code{split} character(s) are not
#' included in the output), \code{2} (\code{split} character(s) are included at
#' the beginning of the output), or \code{3} (\code{split} character(s) are
#' included at the end of the output).
#' @param regex logical.  If \code{TRUE} regular expressions will be enabled for
#' \code{split} argument.
#' @param \ldots other arguments passed to \code{\link[base]{grep}} and
#' \code{\link[base]{grepl}}.
#' @return Returns a list of vectors.
#' @author Matthew Flickinger and Tyler Rinker <tyler.rinker@@gmail.com>.
#' @references \url{http://stackoverflow.com/a/24319217/1000343}
#' @export
#' @rdname split_match
#' @examples
#' set.seed(15)
#' x <- sample(c("", LETTERS[1:10]), 25, TRUE, prob=c(.2, rep(.08, 10)))
#'
#' split_match(x)
#' split_match(x, "C")
#' split_match(x, c("", "C"))
#'
#' split_match(x, include = 0)
#' split_match(x, include = 1)
#' split_match(x, include = 2)
#'
#' set.seed(15)
#' x <- sample(1:11, 25, TRUE, prob=c(.2, rep(.08, 10)))
#' split_match(x, 1)
split_match <- function(x, split = "", include = FALSE, regex = FALSE, ...) {

    include <- as.numeric(include)

    if (length(include) != 1 || !include %in% 0:2) {
        stop("Supply 0, 1, or 2 to `include`")
    }

    if (include %in% 0:1){
        if (!regex){
            breaks <- x %in% split
        } else {
            breaks <- grepl(split, x, ...)
      }

        if(include == 1) {
            inds <- rep(TRUE, length(breaks))
        } else {
            inds <- !breaks
        }
        out <- split(x[inds], cumsum(breaks)[inds])
        names(out) <- seq_along(out)
        out

    } else {
        if (!regex){
            locs <- which(x %in% split)
        } else {
		locs <- grep(split, x, ...)
        }

        start <- c(1, locs + 1)
        end <- c(locs, length(x))

        lapply(Map(":", start, end), function(ind){
            x[ind]
        })
    }
}


#' Split a Vector By Split Points
#'
#' \code{split_match_regex} - \code{split_match} with \code{regex = TRUE}.
#' 
#' @export
#' @rdname split_match
split_match_regex <- function(x, split = "", include = FALSE, ...){
    split_match(x =x, split = split, include = include, regex = TRUE, ...)
}



