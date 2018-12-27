#' Get Elements Matching Between 2 Points
#' 
#' Use regexes to get all the elements between two points.
#' 
#' @param x A character vector, \code{\link[base]{data.frame}}, or list.
#' @param from A regex to start getting from (if \code{NULL} defaults to the 
#' first element/row).
#' @param to A regex to get up to (if \code{NULL} defaults to the last element/row).
#' @param from.n If more than one element matches \code{from} this dictates 
#' which one should be used.  Must be an integer up to the number of possible
#' matches, \code{'first'} (equal to \code{1}), \code{'last'} (the last match
#' possible), or \code{'n'} (the same as \code{'last'}).
#' @param to.n If more than one element matches \code{to} this dictates 
#' which one should be used.  Must be an integer up to the number of possible
#' matches, \code{'first'} (equal to \code{1}), \code{'last'} (the last match
#' possible), or \code{'n'} (the same as \code{'last'}).
#' @param \ldots Other arguments passed to \code{\link[base]{grep}}, most notable
#' is \code{ignore.case}.
#' @param text.var The name of the text variable with matches. If \code{TRUE}
#' \code{grab_match} tries to detect the text column.
#' @return Returns a subset of the original data set.
#' @export
#' @examples
#' grab_match(DATA$state, from = 'dumb', to = 'liar')
#' grab_match(DATA$state, from = 'dumb')
#' grab_match(DATA$state, to = 'liar')
#' grab_match(DATA$state, from = 'no', to = 'the', ignore.case = TRUE)
#' grab_match(DATA$state, from = 'no', to = 'the', ignore.case = TRUE, 
#'     from.n = 'first', to.n = 'last')
#' grab_match(as.list(DATA$state), from = 'dumb', to = 'liar')
#' 
#' ## Data.frame: attempts to find text.var
#' grab_match(DATA, from = 'dumb', to = 'liar')
grab_match <- function(x, from = NULL, to = NULL, from.n = 1, to.n = 1, ...){

    UseMethod('grab_match')
   
}

#' @export
#' @rdname grab_match
#' @method grab_match character
grab_match.character <- function(x, from = NULL, to = NULL, from.n = 1, to.n = 1, ...){

    locs <- grab_match_helper(x = x, from = from, to = to, from.n = from.n, to.n = to.n)

    grab_index(x, locs[['from.ind']], locs[['to.ind']])
}

#' @export
#' @rdname grab_match
#' @method grab_match list
grab_match.list <- function(x, from = NULL, to = NULL, from.n = 1, to.n = 1, ...){

    locs <- grab_match_helper(x = lapply(x, unlist), from = from, to = to, from.n = from.n, to.n = to.n)

    grab_index(x, locs[['from.ind']], locs[['to.ind']])
}

#' @export
#' @rdname grab_match
#' @method grab_match data.frame
grab_match.data.frame <- function(x, from = NULL, to = NULL, from.n = 1, to.n = 1, 
    text.var = TRUE, ...){

    text.var <- detect_text_column(x, text.var)
    
    locs <- grab_match_helper(x = x[[text.var]], from = from, to = to, from.n = from.n, to.n = to.n)

    grab_index(x, locs[['from.ind']], locs[['to.ind']])
}





grab_match_helper <- function(x, from, to, from.n, to.n, ...){

    from.n <- nth(from.n)
    to.n <- nth(to.n)

    if (is.null(from)) {
        fi <- 1
    } else {
        fi <- get_index(from.n, match_to_index(x, from, use = 'from', ...), use = 'from.n')
    }
    
    
    if (is.null(to)) {
        ti <- length(x)
    } else {    
        ti <- get_index(to.n, match_to_index(x, to, use = 'to', ...), use = 'to.n')
    }
    
    c(
   	     from.ind = fi,
    	 to.ind = ti
    )
      
}


get_index <- function(desired.i, possible.i, use, ...){
    
    if (!is.infinite(desired.i) && desired.i > length(possible.i)) {
        warning(sprintf('desired `%s` exceeds number of matches; using first match instead', use))
        return(possible.i[1])
    }
    if (is.infinite(desired.i)){
        return(possible.i[length(possible.i)])
    }
    possible.i[desired.i]
}


match_to_index <- function(x, regex, use, ...){
    
    if (is.null(regex)) return(NULL)
 
    out <- grep(regex, x, perl = TRUE, ...)
    if (length(out) == 0) stop(sprintf('`%s` did not have any matches', use))
    out
}





