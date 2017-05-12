#' Split Text by Regex Into a Transcript
#'
#' A wrapper for \code{\link[textshape]{split_match_regex}} and \pkg{textreadr}'s
#' \code{as_transript} to detect person variable, split the text into turns of
#' talk, and convert to a data.frame with \code{person} and \code{dialogue}
#' variables.
#'
#' @param x A vector with split points.
#' @param person.regex A vector of places (elements) to split on or a regular
#' expression if \code{regex} argument is \code{TRUE}.
#' @param col.names  A character vector specifying the column names of the
#' transcript columns.
#' @param dash A character string to replace the en and em dashes special
#' characters (default is to remove).
#' @param ellipsis A character string to replace the ellipsis special characters.
#' @param quote2bracket logical. If \code{TRUE} replaces curly quotes with curly
#' braces (default is \code{FALSE}).  If \code{FALSE} curly quotes are removed.
#' @param rm.empty.rows logical.  If \code{TRUE}
#' \code{\link[textreadr]{read_transcript}}  attempts to remove empty rows.
#' @param skip Integer; the number of lines of the data file to skip before
#' beginning to read data.
#' @param \ldots ignored.
#' @return Returns a data.frame of dialogue and people.
#' @export
#' @examples
#' \dontrun{
#' system.file("docs/Simpsons_Roasting_on_an_Open_Fire_Script.pdf", package = "textshape") %>%
#'     textreadr::read_document() %>%
#'     split_match_regex_to_transcript("^[A-Z]{3,}", skip = 2)
#' }
#'
split_match_regex_to_transcript <- function (x, person.regex = "^[A-Z]{3,}",
    col.names = c("Person", "Dialogue"), dash = "", ellipsis = "...",
    quote2bracket = FALSE, rm.empty.rows = TRUE, skip = 0, ...) {

    text2transcript(combine_list(split_match(x, split = person.regex, include = TRUE, regex = TRUE)),
        person.regex = person.regex, col.names = col.names, dash = dash, ellipsis = ellipsis,
        quote2bracket = quote2bracket, rm.empty.rows = rm.empty.rows, skip = skip, ...)

}


combine_list <- function (x, fix.punctuation = TRUE, ...) {
    if (!is.list(x)) x <- list(x)
    x <- unlist(lapply(x, paste, collapse = " "))
    if (isTRUE(fix.punctuation)) {
        x <- gsub("(\\s+(?=[,.?!;:%-]))|((?<=[$-])\\s+)", "", x, perl = TRUE)
    }
    unname(x)
}



text2transcript <- function(text, person.regex = NULL,
    col.names = c("Person", "Dialogue"), text.var = NULL, merge.broke.tot = TRUE,
    header = FALSE, dash = "", ellipsis = "...", quote2bracket = FALSE,
    rm.empty.rows = TRUE, na = "", skip = 0, ...) {

    sep <- ":"
    text <- unlist(strsplit(text, "\n"))
    text <- paste(gsub(paste0('(', person.regex, ')'), "\\1SEP_PLACE_HOLDER", text, perl = TRUE), collapse = "\n")

    text <- gsub(":", "SYMBOL_PLACE_HOLDER", text)
    text <- gsub("SEP_PLACE_HOLDER", ":", text, fixed = TRUE)

    ## Use read.table to split read the text as a table
    x <- utils::read.table(text=text, header = header, sep = sep, skip=skip, quote = "")
    x[[2]] <- gsub("SYMBOL_PLACE_HOLDER", ":", x[[2]], fixed = TRUE)

    if (!is.null(text.var) & !is.numeric(text.var)) {
        text.var <- which(colnames(x) == text.var)
    } else {
        text.col <- function(dataframe) {
            dial <- function(x) {
                if(is.factor(x) | is.character(x)) {
                    n <- max(nchar(as.character(x)), na.rm = TRUE)
                } else {
                    n <- NA
                }
            }
            which.max(unlist(lapply(dataframe, dial)))
        }
        text.var <- text.col(x)
    }

    x[[text.var]] <- trimws(iconv(as.character(x[[text.var]]), "", "ASCII", "byte"))
    if (is.logical(quote2bracket)) {
        if (quote2bracket) {
            rbrac <- "}"
            lbrac <- "{"
        } else {
            lbrac <- rbrac <- ""
        }
    } else {
            rbrac <- quote2bracket[2]
            lbrac <- quote2bracket[1]
    }

    ser <- c("<e2><80><9c>", "<e2><80><9d>", "<e2><80><98>", "<e2><80><99>",
    	"<e2><80><9b>", "<ef><bc><87>", "<e2><80><a6>", "<e2><80><93>",
    	"<e2><80><94>", "<c3><a1>", "<c3><a9>", "<c2><bd>")

    reps <- c(lbrac, rbrac, "'", "'", "'", "'", ellipsis, dash, dash, "a", "e", "half")

    Encoding(x[[text.var]]) <-"latin1"
    x[[text.var]] <- clean(mgsub(ser, reps, x[[text.var]]))
    if(rm.empty.rows) {
        x <- rm_empty_row(x)
    }
    if (!is.null(col.names)) {
        colnames(x) <- col.names
    }

    x <- as.data.frame(x, stringsAsFactors = FALSE)

    if (merge.broke.tot) {
        x <- combine_tot(x)
    }
    x <- rm_na_row(x, rm.empty.rows)
    class(x) <- c("textreadr", "data.frame")
    x
}


rm_na_row <- function(x, remove = TRUE) {
    if (!remove) return(x)
    x[rowSums(is.na(x)) != ncol(x), ]
}


#Helper function used in read.transcript
#' @importFrom data.table :=
combine_tot <- function(x){
    nms <- colnames(x)
    colnames(x) <- c('person', 'z')
    x <- data.table::data.table(x)

    exp <- parse(text='list(text = paste(z, collapse = " "))')[[1]]
    out <- x[, eval(exp),
        by = list(person, 'new' = data.table::rleid(person))][,
        'new' := NULL][]
    data.table::setnames(out, nms)
    out
}

