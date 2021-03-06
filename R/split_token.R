#' Split Tokens
#'
#' Split tokens.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with tokens.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{split_token} tries to detect the text column with tokens.
#' @param lower logical.  If \code{TRUE} the words are converted to lower case.
#' @param \ldots Ignored.
#' @export
#' @rdname split_token
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of tokens or an expanded
#' \code{\link[data.table]{data.table}} with tokens split apart.
#' @examples
#' (x <- c(
#'     "Mr. Brown comes! He says hello. i give him coffee.",
#'     "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
#'     "go there"
#' ))
#' split_token(x)
#' split_token(x, lower=FALSE)
#'
#' data(DATA)
#' split_token(DATA)
#' split_token(DATA, lower=FALSE)
#'
#' ## Larger data set
#' split_token(hamlet)
split_token <- function(x, ...) {
    UseMethod("split_token")
}

#' @export
#' @rdname split_token
#' @method split_token default
split_token.default <- function(x, lower = TRUE, ...) {

    if (lower) {
        x <- stringi::stri_trans_tolower(x)
    }
    x <- stringi::stri_replace_all_regex(x, "(^|\\s)(')(\\w.+?)(')(\\s|$)", "$1$2 $3 $4$5")
    x <- trimws(stringi::stri_replace_all_regex(x, "([^'[:^punct:]])", " $1 "))
    stringi::stri_split_regex(x, "\\s+")
}


#' @export
#' @rdname split_token
#' @method split_token data.frame
split_token.data.frame <- function(x, text.var = TRUE, lower = TRUE, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    text.var <- detect_text_column(x, text.var)

    z[, element_id := 1:.N]
    express1 <- parse(
        text=paste0(
            text.var, 
            " := list(split_token.default(", 
            text.var, 
            ", lower = ", 
            lower, 
            "))"
        )
    )
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, 
        c(nms, "element_id"), with = FALSE]
    z[, 'token_id' := 1:.N, by = list(element_id)][]

}
