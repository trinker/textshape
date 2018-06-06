#' Split Sentences & Tokens
#'
#' Split sentences and tokens.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with sentences.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{split_sentence_token} tries to detect the column with sentences.
#' @param lower logical.  If \code{TRUE} the words are converted to lower case.
#' @param \ldots Ignored.
#' @export
#' @rdname split_sentence_token
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of sentences or a expanded
#' \code{\link[base]{data.frame}} with sentences split apart.
#' @examples
#' (x <- c(paste0(
#'     "Mr. Brown comes! He says hello. i give him coffee.  i will ",
#'     "go at 5 p. m. eastern time.  Or somewhere in between!go there"
#' ),
#' paste0(
#'     "Marvin K. Mooney Will You Please Go Now!", "The time has come.",
#'     "The time has come. The time is now. Just go. Go. GO!",
#'     "I don't care how."
#' )))
#' split_sentence_token(x)
#'
#' data(DATA)
#' split_sentence_token(DATA)
#'
#' \dontrun{
#' ## Kevin S. Dias' sentence boundary disambiguation test set
#' data(golden_rules)
#' library(magrittr)
#'
#' golden_rules %$%
#'     split_sentence_token(Text)
#' }
split_sentence_token <- function(x,  ...) {
    UseMethod("split_sentence_token")
}

#' @export
#' @rdname split_sentence_token
#' @method split_sentence_token default
split_sentence_token.default <- function(x, lower = TRUE, ...) {
    
    split_sentence_token.data.frame(data.frame(text = x, 
        stringsAsFactors = FALSE))
    
}

#' @export
#' @rdname split_sentence_token
#' @method split_sentence_token data.frame
split_sentence_token.data.frame <- function(x, text.var = TRUE, 
    lower = TRUE, ...) {

    element_id <- NULL
    z <- split_sentence(x, text.var = text.var, ...)

    nms <- colnames(z)

    text.var <- detect_text_column(z, text.var)
    
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
        c(nms), with = FALSE]
    z[, 'token_id' := 1:.N, by = list(element_id)][]

}






