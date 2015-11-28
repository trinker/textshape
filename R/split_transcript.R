#' Split a Transcript Style Vector on Deliminator & Coerce to Dataframe
#'
#' Split a transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}
#' into a name and dialogue vector that is coerced to a \code{\link[data.table]{data.table}}.
#' Leading/trailing white space in the columns is stripped out.
#'
#' @param x A transcript style vector (e.g., \code{c("greg: Who me", "sarah: yes you!")}.
#' @param delim The deliminator to split on.
#' @param colnames The column names to use for the \code{\link[data.table]{data.table}} output.
#' @return Returns a \code{\link[data.table]{data.table}}.
#' @export
#' @examples
#' split_transcript(c("greg: Who me", "sarah: yes you!"))
split_transcript <- function(x, delim = ":", colnames = c("person", "dialogue")){
    x <- sub(delim, "textshapesplithere", x)
    dat <- data.table::data.table(do.call(rbind,strsplit(x , "textshapesplithere")))[, V1 := trimws(V1)
        ][,V2 := trimws(V2)][]
    data.table::setnames(dat, c("V1", "V2"), colnames)
    dat
}
