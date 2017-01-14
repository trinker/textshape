#' Tidy a Named Atomic Vector: Bind Its Values with Its Names
#'
#' \code{\link[base]{cbind}} a named atomic \code{\link[base]{vector}}'s values
#' with its \code{\link[base]{names}} to form \code{id} (from the names) and
#' \code{content} columns.
#'
#' @param x A named atomic \code{\link[base]{vector}}.
#' @param id.name The name to use for the column created from the \code{\link[base]{vector}}
#' \code{\link[base]{names}}.
#' @param content.name The name to use for the column created from the \code{\link[base]{vector}}
#' values.
#' @param as.tibble logical.  If \code{TRUE} the output class will be set to a
#' \pkg{tibble}, otherwise a \code{\link[data.table]{data.table}}.  Default
#' checks \code{getOption("tibble.out")} as a logical.  If this is \code{NULL}
#' the default \code{\link[textshape]{tibble_output}} will set \code{as.tibble}
#' to \code{TRUE} if \pkg{dplyr} is loaded.  Otherwise, the output will be a
#' \code{\link[data.table]{data.table}}.
#' @param \ldots ignored.
#' @return Returns a \code{\link[data.table]{data.table}} with the \code{\link[base]{names}}
#' from the \code{\link[base]{vector}} as an \code{id} column.
#' @export
#' @examples
#' x <- setNames(sample(LETTERS[1:6], 1000, TRUE), sample(state.name[1:5], 1000, TRUE))
#' tidy_vector(x)
tidy_vector <- function(x, id.name= "id", content.name = "content",
    as.tibble = tibble_output(), ...){

    stopifnot(is.atomic(x))
    if (is.null(names)) {
        out <- data.table::as.data.table(x)
        data.table::setnames(out, id.name)
    } else {
        out <- data.table::data.table(x = names(x), y = unname(x))
        data.table::setnames(out, c(id.name, content.name))
    }
    if_tibble(out, as.tibble = as.tibble)
}


