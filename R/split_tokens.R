#' Split Tokens
#'
#' Split tokens.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with tokens.
#' @param text.var The name of the text variable.  If missing
#' \code{split_tokens} tries to detect the text column with tokens.
#' @param lower logical.  If \code{TRUE} the words are converted to lower case.
#' @param \ldots Ignored.
#' @export
#' @rdname split_tokens
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of tokens or an expanded
#' \code{\link[base]{data.frame}} with tokens split apart.
#' @examples
#' (x <- c(
#'     "Mr. Brown comes! He says hello. i give him coffee.",
#'     "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
#'     "go there"
#' ))
#' split_tokens(x)
#' split_tokens(x, lower=FALSE)
#'
#' data(DATA)
#' split_tokens(DATA)
#' split_tokens(DATA, lower=FALSE)
#'
#' ## Larger data set
#' split_tokens(hamlet)
split_tokens <- function(x, ...) {
    UseMethod("split_tokens")
}

#' @export
#' @rdname split_tokens
#' @method split_tokens default
split_tokens.default <- function(x, lower = TRUE, ...) {
    if (lower) {
        x <- stringi::stri_trans_tolower(x)
    }
    stringi::stri_split_regex(x, "(\\s+)|(?!')(?=[[:punct:]])")
}

#' @export
#' @rdname split_tokens
#' @method split_tokens data.frame
split_tokens.data.frame <- function(x, text.var = TRUE, lower = TRUE, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    if (isTRUE(text.var)) {
        text.var <- names(which.max(sapply(as.data.frame(z), function(y) {
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)))
        }))[1])
        if (length(text.var) == 0) stop("Could not detect ` text.var`.  Please supply `text.var` explicitly.")
    }

    z[, element_id := 1:.N]
    express1 <- parse(text=paste0(text.var, " := split_tokens.default(", text.var, ", lower = ", lower, ")"))
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'sentence_id' := 1:.N, by = list(element_id)][]

}
