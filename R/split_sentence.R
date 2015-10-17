#' Split Sentences
#'
#' Split sentences.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with sentences.
#' @param text.var The name of the text variable.  If missing
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
split_sentence <- function(x, ...) {
    UseMethod("split_sentence")
}

#' @export
#' @rdname split_sentence
#' @method split_sentence default
split_sentence.default <- function(x, ...) {
    lapply(lapply(get_sents2(x), function(x) gsub("<<<TEMP>>>", ".", x)),
        function(x) gsub("^\\s+|\\s+$", "", x))
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
            mean(nchar(as.character(y)))
        }))[1])
        if (length(text.var) == 0) stop("Could not detect ` text.var`.  Please supply `text.var` explicitly.")
    }

    z[, element_id := 1:.N]
    express1 <- parse(text=paste0(text.var, " := get_sentences2(", text.var, ")"))
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'sentence_id' := 1:.N, by = list(element_id)][]

}








