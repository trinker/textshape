#' Split a Transcript Style Vector on Delimiter & Coerce to Dataframe
#'
#' Split a transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}
#' into a name and dialogue vector that is coerced to a \code{\link[data.table]{data.table}}.
#' Leading/trailing white space in the columns is stripped out.
#'
#' @param x A transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}.
#' @param delim The delimiter to split on.
#' @param colnames The column names to use for the \code{\link[data.table]{data.table}}
#' output.
#' @param max.delim An integer stating how many characters may come before a
#' delimiter is found.  This is useful for the case when a colon is the delimiter
#' but time stamps are also found in the text.
#' @param \ldots Ignored.
#' @return Returns a 2 column \code{\link[data.table]{data.table}}.
#' @export
#' @examples
#' split_transcript(c("greg: Who me", "sarah: yes you!"))
#'
#' \dontrun{
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
#' })
#' }
split_transcript <- function(x, delim = ":", colnames = c("person", "dialogue"),
    max.delim = 15, ...){

    V1 <- V2 <- NULL
    if (!is.null(max.delim)) {
        x <- gsub(paste0('(^[^',delim, ']{0,', max.delim, '})([', delim, '])(.*$)'), "\\1textshapesplithere\\3", x, perl = TRUE)
    } else {
        x <- sub(delim, "textshapesplithere", x)
    }
    dat <- data.table::data.table(do.call(rbind, strsplit(x , "textshapesplithere")))[,
        V1 := trimws(V1)][,
        V2 := trimws(V2)][]
    data.table::setnames(dat, c("V1", "V2"), colnames)
    dat
}
