#' Split Sentences
#'
#' Split sentences.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with sentences.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{split_sentence} tries to detect the column with sentences.
#' @param \ldots Ignored.
#' @export
#' @rdname split_sentence
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of sentences or a expanded
#' \code{\link[base]{data.frame}} with sentences split apart.
#' @examples
#' (x <- paste0(
#'     "Mr. Brown comes! He says hello. i give him coffee.  i will ",
#'     "go at 5 p. m. eastern time.  Or somewhere in between!go there"
#' ))
#' split_sentence(x)
#'
#' data(DATA)
#' split_sentence(DATA)
#'
#' y <- c(paste(
#'     "\x91He has asked the Administration to be sent there,\x92 said the",
#'     "other, \x91with the idea of showing what he could do; and I was instructed",
#'     "accordingly.\x92 They both agreed it was frightful, then made several",
#'     "bizarre remarks: \x91Make rain and fine weather\x-one man\x-the Council\x-by the",
#'     "nose\x92\x-bits of absurd sentences that got the better of my drowsiness when",
#'     "the uncle said, \x91The climate may do away with this difficulty for you.",
#'     "And one more, \x93How bout that!\x94 But still there is \x93another.\x94,",
#'     "but who?  No. 3 will.  No.  He will not!",
#'     collapse = ' '
#' ), "I said no.  Now stop!", "I will not!  Yes you will.")
#' Encoding(y) <- "latin1"
#' y
#' ## doesn't work as expected because of encoding issue
#' split_sentence(y)
#'
#' \dontrun{
#' library(textclean)
#' replace_curly <- function(x, ...){
#'     replaces <- c('\x91', '\x92', '\x93', '\x94')
#'     Encoding(replaces) <- "latin1"
#'     textclean::mgsub(x, replaces, c("'", "'", "\"", "\""))
#' }
#' split_sentence(replace_curly(y))
#' }
split_sentence <- function(x, ...) {
    UseMethod("split_sentence")
}

#' @export
#' @rdname split_sentence
#' @method split_sentence default
split_sentence.default <- function(x, ...) {
    get_sents2(x)
}

#' @export
#' @rdname split_sentence
#' @method split_sentence data.frame
split_sentence.data.frame <- function(x, text.var = TRUE, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    if (isTRUE(text.var)) {
        text.var <- names(which.max(sapply(as.data.frame(z), function(y) {
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)), na.rm = TRUE)
        }))[1])
        if (length(text.var) == 0) stop("Could not detect `text.var`.  Please supply `text.var` explicitly.")
    }

    z[, element_id := 1:.N]
    express1 <- parse(text=paste0(text.var, " := get_sents2(", text.var, ")"))
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'sentence_id' := 1:.N, by = list(element_id)][]

}








