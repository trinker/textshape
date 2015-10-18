#' Split Runs
#'
#' Split runs of consecutive characters.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with runs.
#' @param text.var The name of the text variable.
#' @param \ldots Ignored.
#' @export
#' @rdname split_run
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of runs or an expanded
#' \code{\link[data.table]{data.table}} with runs split apart.
#' @examples
#' x1 <- c(
#'      "122333444455555666666",
#'      NA,
#'      "abbcccddddeeeeeffffff",
#'      "sddfg",
#'      "11112222333"
#' )
#'
#' x <- c(rep(x1, 2), ">>???,,,,....::::;[[")
#'
#' split_run(x)
#'
#'
#' DATA[["run.col"]] <- x
#' split_run(DATA, "run.col")
split_run <- function(x, ...) {
    UseMethod("split_run")
}

#' @export
#' @rdname split_run
#' @method split_run default
split_run.default <- function(x, ...) {
    stringi::stri_split_regex(x,  "(?<=(\\w))(?!\\1)")
}

#' @export
#' @rdname split_run
#' @method split_run data.frame
split_run.data.frame <- function(x, text.var, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    z[, element_id := 1:.N]
    express1 <- parse(text=paste0(text.var, " := split_run.default(", text.var, ")"))
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'sentence_id' := 1:.N, by = list(element_id)][]

}
