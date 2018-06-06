#' Duration of Turns of Talk
#'
#' \code{duration} - Calculate duration (start and end times) for duration of 
#' turns of talk measured in words.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with a text
#' variable or a numeric vector.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{duration} tries to detect the text column.
#' @param grouping.var The grouping variables.  Default \code{NULL} generates
#' one word list for all text.  Also takes a single grouping variable or a list
#' of 1 or more grouping variables.
#' @param \ldots Ignored.
#' @export
#' @rdname duration
#' @importFrom data.table .N :=
#' @return Returns a vector or data frame of starts and/or ends.
#' @examples
#' (x <- c(
#'     "Mr. Brown comes! He says hello. i give him coffee.",
#'     "I'll go at 5 p. m. eastern time.  Or somewhere in between!",
#'     "go there"
#' ))
#' duration(x)
#' group <- c("A", "B", "A")
#' duration(x, group)
#'
#' groups <- list(group1 = c("A", "B", "A"), group2 = c("red", "red", "green"))
#' duration(x, groups)
#'
#' data(DATA)
#' duration(DATA)
#'
#' ## Larger data set
#' duration(hamlet)
#'
#' ## Integer values
#' x <- sample(1:10, 10)
#' duration(x)
#' starts(x)
#' ends(x)
duration <- function(x, ...) {
    UseMethod("duration")
}

#' @export
#' @rdname duration
#' @method duration default
duration.default <- function(x, grouping.var = NULL, ...) {

    if(is.null(grouping.var)) {
        G <- "all"
        ilen <- 1
    } else {
        if (is.list(grouping.var)) {
            m <- unlist(as.character(substitute(grouping.var))[-1])
            m <- sapply2(strsplit(m, "$", fixed=TRUE), function(x) {
                    x[length(x)]
                }
            )
            ilen <- length(grouping.var)
            G <- paste(m, collapse="&")
        } else {
            G <- as.character(substitute(grouping.var))
            ilen <- length(G)
            G <- G[length(G)]
        }
    }
    if(is.null(grouping.var)){
        grouping <- rep("all", length(x))
    } else {
        if (is.list(grouping.var) & length(grouping.var)>1) {
            grouping <- grouping.var
        } else {
            grouping <- unlist(grouping.var)
        }
    }
    if (G == "") G <- paste(names(grouping.var), collapse="&")

    dat <- stats::setNames(
        data.frame(as.data.frame(grouping), x),
        c(strsplit(G, "&")[[1]], "text.var")
    )

    duration.data.frame(dat, "text.var")

}

#' @export
#' @rdname duration
#' @method duration data.frame
duration.data.frame <- function(x, text.var = TRUE, ...) {

    word.count <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    text.var <- detect_text_column(x, text.var)

    express1 <- parse(
        text=paste0("word.count := stringi::stri_count_words(", text.var, ")")
    )
    
    z[, eval(express1)][,
        'word.count' := ifelse(is.na(word.count), 0, word.count)][,
        'end' := cumsum(word.count)]

    z[["start"]] <- c(1, utils::head(z[["end"]] + 1, -1))

    colord <- c(nms[!nms %in% text.var], "word.count", "start", "end", text.var)
    data.table:: setcolorder(z, colord)
    
    z[]
    
}


#' @export
#' @rdname duration
#' @method duration numeric
duration.numeric <- function(x, ...){
    dat <- data.frame(x = x, end = cumsum(x))
    dat[["start"]] <- c(1, utils::head(dat[["end"]] + 1 , -1))
    dat[c(1, 3:2)]
}


#' Duration of Turns of Talk
#'
#' \code{startss} - Calculate start times from a numeric vector.
#'
#' @rdname duration
#' @export
starts <- function(x, ...) c(1, utils::head(ends(x) + 1 , -1))



#' Duration of Turns of Talk
#'
#' \code{ends} - Calculate end times from a numeric vector.
#'
#' @rdname duration
#' @export
ends <- function(x, ...) cumsum(x)

