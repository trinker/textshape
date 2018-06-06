#' Column Bind an Atomic Vector's Values with Its Names
#'
#' Deprecated, use \code{\link[textshape]{tidy_vector}} instead.
#'
#' @param x A named atomic \code{\link[base]{vector}}.
#' @param id.name The name to use for the column created from the \code{\link[base]{vector}}
#' \code{\link[base]{names}}.
#' @param content.name The name to use for the column created from the \code{\link[base]{vector}}
#' values.
#' @param \ldots ignored.
#' @return Returns a \code{\link[data.table]{data.table}} with the \code{\link[base]{names}}
#' from the \code{\link[base]{vector}} as an \code{id} column.
#' @export
#' @examples
#' \dontrun{
#' x <- setNames(sample(LETTERS[1:6], 1000, TRUE), sample(state.name[1:5], 1000, TRUE))
#' bind_vector(x)
#' }
bind_vector <- function(x, id.name= "id", content.name = "content", ...){

    warning(
        paste0(
            "Deprecated, use textshape::tidy_vector() instead.\n`bind_vector()` ", 
            "will be removed in the next version."
        ), 
        call. = FALSE
    )

    stopifnot(is.atomic(x))
    
    if (is.null(names)) {
        out <- data.table::as.data.table(x)
        data.table::setnames(out, id.name)
    } else {
        out <- data.table::data.table(x = names(x), y = unname(x))
        data.table::setnames(out, c(id.name, content.name))
    }
    out
}


