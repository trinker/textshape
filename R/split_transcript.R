#' Split a Transcript Style Vector on Delimitor & Coerce to Dataframe
#'
#' Split a transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}
#' into a name and dialogue vector that is coerced to a \code{\link[data.table]{data.table}}.
#' Leading/trailing white space in the columns is stripped out.
#'
#' @param x A transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}.
#' @param delim The delimitor to split on.
#' @param colnames The column names to use for the \code{\link[data.table]{data.table}} output.
#' @return Returns a 2 column \code{\link[data.table]{data.table}}.
#' @export
#' @examples
#' split_transcript(c("greg: Who me", "sarah: yes you!"))
#'
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load(rvest, magrittr)
#'
#' debates <- c(
#'     wisconsin = "110908",
#'     boulder = "110906",
#'     california = "110756",
#'     ohio = "110489"
#' )
#'
#' lapply(debates, function(x){
#'     txt <- read_html(paste0("http://www.presidency.ucsb.edu/ws/index.php?pid=", x)) %>%
#'         html_nodes("p") %>%
#'         html_text()
#'
#'     sapply(split_index(txt, grep("^[A-Z]+:", txt)), paste, collapse = " ") %>%
#'         split_transcript() %>%
#'         split_sentence()
#' })
#' }
split_transcript <- function(x, delim = ":", colnames = c("person", "dialogue")){
    x <- sub(delim, "textshapesplithere", x)
    dat <- data.table::data.table(do.call(rbind,strsplit(x , "textshapesplithere")))[, V1 := trimws(V1)
        ][,V2 := trimws(V2)][]
    data.table::setnames(dat, c("V1", "V2"), colnames)
    dat
}
