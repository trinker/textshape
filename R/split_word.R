#' Split Words
#'
#' Split words.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with words.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{split_word} tries to detect the text column with words.
#' @param lower logical.  If \code{TRUE} the words are converted to lower case.
#' @param \ldots Ignored.
#' @export
#' @rdname split_word
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of words or an expanded
#' \code{\link[data.table]{data.table}} with words split apart.
#' @examples
#' (x <- c(
#'     "Mr. Brown comes! He says hello. i give him coffee.",
#'     "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
#'     "go there"
#' ))
#' split_word(x)
#' split_word(x, lower=FALSE)
#'
#' data(DATA)
#' split_word(DATA)
#' split_word(DATA, lower=FALSE)
#'
#' ## Larger data set
#' split_word(hamlet)
split_word <- function(x, ...) {
    UseMethod("split_word")
}

#' @export
#' @rdname split_word
#' @method split_word default
split_word.default <- function(x, lower = TRUE, ...) {
    if (lower) {
        x <- stringi::stri_trans_tolower(x)
    }
    stringi::stri_extract_all_words(x)
}

#' @export
#' @rdname split_word
#' @method split_word data.frame
split_word.data.frame <- function(x, text.var = TRUE, lower = TRUE, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    text.var <- detect_text_column(x, text.var)

    z[, element_id := 1:.N]
    express1 <- parse(
        text=paste0(
            text.var, 
            " := list(split_word.default(", 
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
    z[, 'word_id' := 1:.N, by = list(element_id)][]

}
