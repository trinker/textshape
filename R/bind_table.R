#' Column Bind a Table's Values with Its Names
#'
#' Deprecated, use \code{\link[textshape]{tidy_table}} instead.
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
#' \dontrun{
#' x <- table(sample(LETTERS[1:6], 1000, TRUE))
#' bind_table(x)
#' }
bind_table <- function(x, id.name= "id", content.name = "content", ...){

    warning(
        paste0(
            "Deprecated, use textshape::tidy_table() instead.\n`bind_table()` ", 
            "will be removed in the next version."
        ), 
        call. = FALSE
    )

    stopifnot(is.table(x))
    
    out <- data.table::data.table(x = names(x), y = unname(c(x)))
    data.table::setnames(out, c(id.name, content.name))
    out

}

