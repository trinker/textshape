#' Combine Elements
#'
#' Combine (\code{\link[base]{paste}}) elements (\code{\link[base]{vector}}s,
#' \code{\link[base]{list}}s, or \code{\link[base]{data.frame}}s) together
#' with \code{collapse = TRUE}.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with runs.
#' @param text.var The name of the text variable.
#' @param fix.punctuation logical If \code{TRUE} spaces before/after punctuation
#' that should not be are a removed (regex used:
#' \code{"(\\s+(?=[,.?!;:\%-]))|((?<=[$-])\\s+)"}).
#' @param \ldots Ignored.
#' @export
#' @rdname combine
#' @return Returns a vector (if given a list/vector) or an expanded
#' \code{\link[data.table]{data.table}} with elements pasted together.
#' @examples
#' (x <- split_token(DATA[["state"]][1], FALSE))
#' combine(x)
#'
#' (x2 <- split_token(DATA[["state"]], FALSE))
#' combine(x2)
#'
#' (x3 <- split_sentence(DATA))
#'
#' ## without dropping the non-group variable column
#' combine(x3)
#'
#' ## Dropping the non-group variable column
#' combine(x3[, 1:5, with=FALSE])
combine <- function(x, ...) {
    UseMethod("combine")
}

#' @export
#' @rdname combine
#' @method combine default
combine.default <- function(x, fix.punctuation = TRUE, ...) {

    if(!is.list(x)) x <- list(x)
    x <- unlist(lapply(x, paste, collapse = " "))
    if (isTRUE(fix.punctuation)){
        x <- gsub("(\\s+(?=[,.?!;:%-]))|((?<=[$-])\\s+)", "", x, perl = TRUE)
    }
    unname(x)
}

#' @export
#' @rdname combine
#' @method combine data.frame
combine.data.frame <- function(x, text.var = TRUE, ...) {

    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    if (isTRUE(text.var)) {
        text.var <- names(which.max(sapply(as.data.frame(z), function(y) {
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)))
        }))[1])
        if (length(text.var) == 0) stop("Could not detect ` text.var`.  Please supply `text.var` explicitly.")
    }

    group.vars <- nms[!nms %in% text.var]

    express1 <- parse(text=
        paste0(
            "list(",
            text.var,
            " = paste(",
            text.var,
            ", collapse = \" \"))"
        )
    )
    z <- z[, eval(express1), by = group.vars]
    data.table::setcolorder(z, nms)
    z
}

