#' Reorder a Matrix Based on Hierarchical Clustering
#' 
#' Reorder a matrice's rows, columns, or both via hierarchical clustering.
#' 
#' @param x A matrix.
#' @param dim The dimension to reorder (cluster); must be set to "row", "col", 
#' or "both".
#' @param method The agglomeration method to be used (see \code{\link[stats]{hclust}}).
#' @param \ldots ignored.
#' @return Returns a reordered matrix.
#' @export
#' @seealso \code{\link[stats]{hclust}}
#' @examples
#' cluster_matrix(mtcars)
#' cluster_matrix(mtcars, dim = 'row')
#' cluster_matrix(mtcars, dim = 'col')
cluster_matrix <- function(x, dim = 'both', method = "ward.D2", ...){
    
    stopifnot(is.matrix(x))
    
    switch(dim,
        row = {
                hc1 <- stats::hclust(stats::dist(x), method = method)
                x[hc1$order, ]
            },
        col = {
                hc2 <- stats::hclust(stats::dist(t(x)), method = method)
                x[, hc2$order]
            },
        both = {
                hc1 <- stats::hclust(stats::dist(x), method = method)
                hc2 <- stats::hclust(stats::dist(t(x)), method = method)
                x[hc1$order, hc2$order]
        },
        stop('`dim` must be set to "row", "col", or "both"')
    )
    
}
