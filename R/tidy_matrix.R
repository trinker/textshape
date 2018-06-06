#' Convert a Matrix into Tidy Form
#' 
#' \code{tidy_matrix} - Converts matrices into a tidy data set.  Essentially, a
#' stacking of the matrix columns and repeating row/column names as necessary.
#' 
#' @param x A matrix.
#' @param row.name A string to use for the row names that are now a column.
#' @param col.name A string to use for the column names that are now a column.
#' @param value.name A string to use for the values that are now a column.
#' @param \ldots ignored.
#' @return Returns a tidied \code{data.frame}.
#' @export
#' @rdname tidy_matrix
#' @examples
#' mat <- matrix(1:16, nrow = 4,
#'     dimnames = list(LETTERS[1:4], LETTERS[23:26])
#' )
#' 
#' mat
#' tidy_matrix(mat)
#' 
#' 
#' data(simple_dtm)
#' tidy_matrix(as.matrix(simple_dtm), 'doc', 'term', 'n')
#' 
#' X <- as.matrix(simple_dtm[1:10, 1:10])
#' tidy_adjacency_matrix(crossprod(X))
#' tidy_adjacency_matrix(crossprod(t(X)))
tidy_matrix <- function(x, row.name = 'row', col.name = 'col', 
    value.name = 'value', ...){
    
    stopifnot(is.matrix(x))
    
    out <- data.table::data.table(x = rep(rownames(x), ncol(x)), 
        y = rep(colnames(x), each = nrow(x)), 
        z = c(x))
    data.table::setnames(out, c(row.name, col.name, value.name)) 
    
    out
    
}

#' Convert a Matrix into Tidy Form
#' 
#' \code{tidy_adjacency_matrix} - A wrapper for \code{tidy_matrix} with the 
#' \code{row.name}, \code{col.name}, & \code{value.name} all set to 
#' \code{"from"},\code{"to"}, & \code{"n"}, assuming preparation for network 
#' analysis.
#' 
#' @export
#' @rdname tidy_matrix
tidy_adjacency_matrix <- function(x, ...){
    
    tidy_matrix(x, row.name = 'from', col.name = 'to', value.name = 'n', ...)
    
}



