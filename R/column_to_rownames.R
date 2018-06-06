#' Add a Column as Rownames
#'
#' Takes an existing column and uses it as rownames instead.  This is useful
#' when turning a \code{\link[base]{data.frame}} into a \code{\link[base]{matrix}}.
#' Inspired by the \pkg{tibble} package's \code{column_to_row} which is now
#' deprecated if done on a \pkg{tibble} object.  By coercing to a
#' \code{\link[base]{data.frame}} this problem is avoided.
#'
#' @param x An object that can be coerced to a \code{\link[base]{data.frame}}.
#' @param loc The column location as either an integer or string index location.
#' Must be unique row names.
#' @return Returns a \code{\link[base]{data.frame}} with the specified column
#' moved to rownames.
#' @export
#' @examples
#' state_dat <- data.frame(state.name, state.area, state.center, state.division)
#' column_to_rownames(state_dat)
#' column_to_rownames(state_dat, 'state.name')
column_to_rownames <- function(x, loc = 1){
    
    x <- as.data.frame(x, check.names = FALSE, stringsAsFactors = FALSE)
    if (!is.numeric(loc)) loc <- which(names(x) %in% loc)[1]
    rownames(x) <- x[[loc]]
    x[[loc]] <- NULL
    x
    
}
