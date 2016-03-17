#' Tabulate Frequency Counts for Multiple Vectors
#'
#' \code{mtabulate} - Similar to \code{\link[base]{tabulate}} that works on multiple vectors.
#'
#' @param vects A \code{\link[base]{vector}}, \code{\link[base]{list}}, or
#' \code{\link[base]{data.frame}} of named/unnamed vectors.
#' @keywords tabulate frequency
#' @export
#' @seealso \code{\link[base]{tabulate}}, \code{\link[qdapTools]{counts2list}}
#' @return \code{mtabulate} - Returns a \code{\link[base]{data.frame}} with columns equal to
#' number of unique elements and the number of rows equal to the the original
#' length of the \code{\link[base]{vector}}, \code{\link[base]{list}}, or
#' \code{\link[base]{data.frame}} (length equals ncols in
#' \code{\link[base]{data.frame}}).  If list of vectors is named
#' these will be the rownames of the dataframe.
#' @author Joran Elias and Tyler Rinker <tyler.rinker@@gmail.com>.
#' @rdname mtabulate
#' @references \url{http://stackoverflow.com/a/9961324/1000343}
#' @examples
#' mtabulate(list(w=letters[1:10], x=letters[1:5], z=letters))
#' mtabulate(list(mtcars$cyl[1:10]))
#'
#' ## Dummy coding
#' mtabulate(mtcars$cyl[1:10])
#' mtabulate(CO2[, "Plant"])
#'
#' dat <- data.frame(matrix(sample(c("A", "B"), 30, TRUE), ncol=3))
#' mtabulate(dat)
#' as_list(mtabulate(dat))
#' t(mtabulate(dat))
#' as_list(t(mtabulate(dat)))
mtabulate <- function(vects) {
    lev <- sort(unique(unlist(vects)))
    dat <- do.call(rbind, lapply(vects, function(x, lev){
        tabulate(factor(x, levels = lev, ordered = TRUE),
        nbins = length(lev))}, lev = lev))
    colnames(dat) <- sort(lev)
    data.frame(dat, check.names = FALSE)
}



#' Tabulate Frequency Counts for Multiple Vectors
#'
#' \code{as_list} - Convert a count matrix to a named list of elements.  The
#' semantic inverse of \code{mtabulate}.
#'
#' @param mat A matrix of counts.
#' @param nm A character vector of names to assign to the list.
#' @rdname mtabulate
#' @return \code{as_list} - Returns a list of elements.
#' @export
as_list <- function(mat, nm = rownames(mat)) {
    nms <- colnames(mat)
    lst <- apply(mat, 1, function(x) rep(nms, x))
    if(!is.list(lst)) lst <- lapply(1:ncol(lst), function(i) lst[, i])
    stats::setNames(lst,  nm = nm)
}



