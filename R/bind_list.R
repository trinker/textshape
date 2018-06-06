#' Row Bind a List of Named Dataframes or Vectors
#'
#' Deprecated, use \code{\link[textshape]{tidy_list}} instead.
#'
#' @param x A named \code{\link[base]{list}} of
#' \code{\link[base]{data.frame}}s or \code{\link[base]{vector}}.
#' @param id.name The name to use for the column created from the \code{\link[base]{list}}.
#' @param content.name The name to use for the column created from the \code{\link[base]{list}}
#' of \code{\link[base]{vector}}s (only used if \code{x} is  \code{\link[base]{vector}}).
#' @param \ldots ignored.
#' @return Returns a \code{\link[data.table]{data.table}} with the \code{\link[base]{names}}
#' from the \code{\link[base]{list}} as an \code{id} column.
#' @export
#' @examples
#' \dontrun{
#' bind_list(list(p=1:500, r=letters))
#' bind_list(list(p=mtcars, r=mtcars, z=mtcars, d=mtcars))
#'
#' ## 2015 Vice-Presidential Debates Example
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load(rvest, magrittr, xml2)
#'
#' debates <- c(
#'     wisconsin = "110908",
#'     boulder = "110906",
#'     california = "110756",
#'     ohio = "110489"
#' )
#'
#' lapply(debates, function(x){
#'     xml2::read_html(paste0("http://www.presidency.ucsb.edu/ws/index.php?pid=", x)) %>%
#'         rvest::html_nodes("p") %>%
#'         rvest::html_text() %>%
#'         textshape::split_index(grep("^[A-Z]+:", .)) %>%
#'         textshape::combine() %>%
#'         textshape::split_transcript() %>%
#'         textshape::split_sentence()
#' }) %>%
#'     textshape::bind_list("location")
#' }
bind_list <- function(x, id.name= "id", content.name = "content", ...){

    warning(
        paste0(
            "Deprecated, use textshape::tidy_list() instead.\n`bind_list()` ", 
            "will be removed in the next version."
        ), 
        call. = FALSE
    )


    if (is.data.frame(x[[1]])){
        bind_list_df(x = x, id.name = id.name)
    } else {

        if (is.vector(x[[1]])){
            bind_list_vector(x = x, id.name = id.name, content.name = content.name)
        } else {
            stop("`x` must be a list of `data.frame`s or `vector`s")
        }
    }
}



bind_list_df <- function (x, id.name = "id"){
    if (is.null(names(x))) {
        names(x) <- seq_along(x)
    }
    list.names <- rep(names(x), sapply2(x, nrow))
    x <- lapply(x, data.table::as.data.table)
    x[['fill']] <- TRUE    
    out <- data.frame(list.names, do.call(rbind, x),
        row.names = NULL, check.names = FALSE, stringsAsFactors = FALSE)
    colnames(out)[1] <- id.name
    data.table::data.table(out)
}

bind_list_vector <- function(x, id.name= "id", content.name = "content"){
    if (is.null(names(x))) {
        names(x) <- seq_along(x)
    }
    dat <- data.frame(
        rep(names(x), sapply2(x, length)),
        unlist(x, use.names = FALSE),
        stringsAsFactors = FALSE,
        check.names = FALSE,
        row.names = NULL
    )
    colnames(dat) <- c(id.name, content.name)
    data.table::data.table(dat)
}



