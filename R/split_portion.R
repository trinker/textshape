#' Break Text Into Ordered Word Chunks
#'
#' Some visualizations and algorithms require text to be broken into chunks of
#' ordered words.  \code{split_portion} breaks text, optionally by grouping
#' variables, into equal chunks.  The chunk size can be specified by giving
#' number of words to be in each chunk or the number of chunks.
#'
#' @param text.var The text variable
#' @param grouping.var The grouping variables.  Default \code{NULL} generates
#' one word list for all text.  Also takes a single grouping variable or a list
#' of 1 or more grouping variables.
#' @param n.words An integer specifying the number of words in each chunk (must
#' specify n.chunks or n.words).
#' @param n.chunks An integer specifying the number of chunks (must specify
#' n.chunks or n.words).
#' @param as.string logical.  If \code{TRUE} the chunks are returned as a single
#' string.  If \code{FALSE} the chunks are returned as a vector of single words.
#' @param rm.unequal logical. If \code{TRUE} final chunks that are unequal in
#' length to the other chunks are removed.
#' @param as.table logical.  If \code{TRUE} the list output is coerced to
#' \code{\link[data.table]{data.table}} or \pkg{tibble}.
#' @param \ldots Ignored.
#' @return Returns a list or \code{\link[data.table]{data.table}} of text chunks.
#' @keywords chunks group text
#' @export
#' @examples
#' with(DATA, split_portion(state, n.chunks = 10))
#' with(DATA, split_portion(state, n.words = 10))
#' with(DATA, split_portion(state, n.chunks = 10, as.string=FALSE))
#' with(DATA, split_portion(state, n.chunks = 10, rm.unequal=TRUE))
#' with(DATA, split_portion(state, person, n.chunks = 10))
#' with(DATA, split_portion(state, list(sex, adult), n.words = 10))
#' with(DATA, split_portion(state, person, n.words = 10, rm.unequal=TRUE))
#'
#' ## Bigger data
#' with(hamlet, split_portion(dialogue, person, n.chunks = 10))
#' with(hamlet, split_portion(dialogue, list(act, scene, person), n.chunks = 10))
#' with(hamlet, split_portion(dialogue, person, n.words = 300))
#' with(hamlet, split_portion(dialogue, list(act, scene, person), n.words = 300))
split_portion <- function(text.var, grouping.var = NULL, n.words, n.chunks,
    as.string = TRUE, rm.unequal = FALSE, as.table = TRUE, ...){

    if (missing(n.chunks) && missing(n.words)) {
        stop("Must supply either `n.chunks` or `n.words`")
    }

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
        grouping <- rep("all", length(text.var))
    } else {
        if (is.list(grouping.var) & length(grouping.var)>1) {
            grouping <- paste2(grouping.var)
        } else {
            grouping <- unlist(grouping.var)
        }
    }

    ## split into ordered words by grouping variable
    dat <- lapply(split(as.character(text.var), grouping), function(x) {
        unlist(stringi::stri_split_regex(x, "\\s+"))
    })


    if (!missing(n.chunks)){

        ## Check that n.chunks is integer
        if (!is.Integer(n.chunks)){
            stop("`n.chunks` must be an integer")
        }
        out <- lapply(
            dat, 
            split_portion_help_groups, 
            N = n.chunks, 
            ub = as.string, 
            rme = rm.unequal
        )

    } else {

        ## Check that n.words is integer
        if (!is.Integer(n.words)){
            stop("`n.words` must be an integer")
        }
        out <- lapply(
            dat, 
            split_portion_help_words, 
            N = n.words, 
            ub = as.string, 
            rme = rm.unequal
        )
    }

    grpvar <- stats::setNames(
        as.data.frame(
            do.call(
                rbind,
                strsplit(names(unlist(out)), "\\.")
            ),
            stringsAsFactors = FALSE
        ), c(strsplit(G, "&")[[1]], "index")
    )

    if (isTRUE(as.table) & isTRUE(as.string)){
        out <- data.frame(
            grpvar,
            text.var = unlist(out),
            stringsAsFactors = FALSE,
            row.names=NULL
        )
        data.table::setDT(out)
        out <- out
    }
    out
}


split_portion_help_groups <- function(x, N, ub, rme){

    len <- length(x)
    size <- floor(len/N)

    ## make the groups, leftover are unequal sized last group
    grabs <- rep(seq_len(N), each = size)
    if (N * size < len){
        leftover <- rep(N + 1, len - N * size)
        grabs <- c(grabs, leftover)
    }

    y <- suppressWarnings(split(x, grabs))
    if (rme){
        ylen <- length(y)
        ## if there is only one chunk it is returned
        if (ylen != 1) {
            lens <- lengths(y)
            if (!Reduce("==", utils::tail(lens, 2))) y <- y[1:(ylen-1)]
        }
    }
    if (ub) y <- lapply(y, paste, collapse = " ")
    y
}

split_portion_help_words <- function(x, N, ub, rme){

    len <- length(x)
    groups <- ceiling(len/N)
    y <- suppressWarnings(split(x, rep(seq_len(groups), each = N)))
    if (rme){
        ylen <- length(y)
        if (ylen == 1) return(NULL)
        if (length(y[[ylen]]) != N) y <- y[1:(ylen-1)]
    }
    if (ub) y <- lapply(y, paste, collapse=" ")
    y
}



