## #' \pkg{textshape} Output Management
## #'
## #' \code{set_output} - Sets \code{getOption("tibble.out")} to \code{TRUE}.
## #' This global option can be used to manage the outputs of many \pkg{textshape}
## #' functions.  Many \pkg{textshape} functions contain a \code{as.tibble}
## #' argument with the default set to \code{\link[textshape]{tibble_output}}.  By
## #' using \code{set_output} the default can be set to a \pkg{tibble} object
## #' when \code{as.tibble = TRUE} or a \pkg{data.table} object when
## #' \code{as.tibble = FALSE}.
## #'
## #' @param as.tibble logical.  If \code{TRUE} the global option
## #' \code{getOption("tibble.out")} is set to \code{TRUE}.
## #' @param \ldots ignored.
## #' @export
## #' @rdname set_output
## #' @examples
## #' ## Current tibble.out option
## #' (opt <- getOption("tibble.out"))
## #'
## #' ## Get tibble output; (defined by getOption("tibble.out")
## #' ## unless missing then defined by whether or not dplyr is loaded
## #' tibble_output()
## #'
## #' ## Set getOption("tibble.out") to FALSE
## #' set_output(FALSE)
## #'
## #' ## Get tibble output (should be FALSE)
## #' tibble_output()
## #'
## #' ## ## Set getOption("tibble.out") to TRUE
## #' set_output(TRUE)
## #'
## #' ## Get tibble output (should be TRUE)
## #' tibble_output()
## #'
## #' ## Reset getOption("tibble.out") to what it was
## #' set_output(opt)
## set_output <- function(as.tibble = TRUE, ...) options(tibble.out = as.tibble)
##
##
##
## #' \pkg{textshape} Output Management
## #'
## #' \code{tibble_output} - Check if the output of \pkg{textshape} should be
## #' a \pkg{tibble} or a \pkg{data.table} object.  If \code{getOption("tibble.out")}
## #' is \code{TRUE} or if \code{getOption("tibble.out")} is \code{NULL} and
## #' \pkg{dplyr} is loaded the function returns \code{TRUE}, otherwise \code{FALSE}.
## #' This is used in most \pkg{textshape} functions to determine if the output
## #' should be \pkg{tibble} or a \pkg{data.table} object.
## #' \code{getOption("tibble.out")} can be set via the
## #' \code{\link[textshape]{set_output}} function.
## #'
## #' @export
## #' @rdname set_output
## tibble_output <- function(){
##     if (isTRUE(getOption("tibble.out"))) return(TRUE)
##     is_dplyr_loaded()
## }
##





