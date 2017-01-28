#' Tidy a Table: Bind Its Values with Its Names
#'
#' \code{\link[base]{cbind}} a \code{\link[base]{table}}'s values with its
#' \code{\link[base]{names}} to form \code{id} (from the names) and
#' \code{content} columns.
#'
#' @param x A \code{\link[base]{table}}.
#' @param id.name The name to use for the column created from the \code{\link[base]{table}}
#' \code{\link[base]{names}}.
#' @param content.name The name to use for the column created from the \code{\link[base]{table}}
#' values.
#' @param \ldots ignored.
#' @return Returns a \code{\link[data.table]{data.table}} with the \code{\link[base]{names}}
#' from the \code{\link[base]{table}} as an \code{id} column.
#' @export
#' @examples
#' x <- table(sample(LETTERS[1:6], 1000, TRUE))
#' tidy_table(x)
tidy_table <- function(x, id.name= "id", content.name = "content", ...){

    stopifnot(is.table(x))
    out <- data.table::data.table(x = names(x), y = unname(c(x)))
    data.table::setnames(out, c(id.name, content.name))
    out

}

