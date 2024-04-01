#' Prepare Discourse Data for Network Plotting
#'
#' \code{from_to} - Add the next speaker as the from variable in a to/from
#' network data structure.  Assumes that the flow of discourse is coming from
#' person A to person B, or at the very least the talk is taken up by person B.
#' Works by taking the vector of speakers and shifting everything down one and
#' then adding a closing element.
#'
#' @param x A data form \code{vector} or \code{data.frame}.
#' @param final The name of the closing element or node.
#' @param \ldots Ignored.
#' @param from.var A character string naming the column to be considered the
#' origin of the talk.
#' @param id.vars The variables that correspond to the speaker or are attributes
#' of the speaker (from variable).
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{duration} tries to detect the text column.
#' @return Returns a vector (if given a vector) or an augmented
#' \code{\link[data.table]{data.table}}.
#' @rdname from_to
#' @export
#' @examples
#' from_to(DATA, 'person')
#' from_to_summarize(DATA, 'person')
#' from_to_summarize(DATA, 'person', c('sex', 'adult'))
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman"); library(pacman)
#' p_load(dplyr, geomnet, qdap, stringi, scales)
#' p_load_current_gh('trinker/textsahpe')
#'
#' dat <- from_to_summarize(DATA, 'person', c('sex', 'adult')) %>%
#'     mutate(words = rescale(word.count, c(.5, 1.5)))
#'
#' dat %>%
#'     ggplot(aes(from_id = from, to_id = to)) +
#'         geom_net(
#'             aes(linewidth = words),
#'             layout.alg = "fruchtermanreingold",
#'             directed = TRUE,
#'             labelon = TRUE,
#'             size = 1,
#'             labelcolour = 'black',
#'             ecolour = "grey70",
#'             arrowsize = 1,
#'             curvature = .1
#'         ) +
#'         theme_net() +
#'         xlim(c(-0.05, 1.05))
#' }
from_to <- function(x, ...){
    UseMethod("from_to")
}

#' @export
#' @method from_to default
#' @rdname from_to
from_to.default <- function(x, final = 'End', ...){
    c(x[-1], final)
}

#' @export
#' @method from_to character
#' @rdname from_to
from_to.character <- function(x, final = 'End', ...){
    c(x[-1], final)
}

#' @export
#' @method from_to factor
#' @rdname from_to
from_to.factor <- function(x, final = 'End', ...){
    factor(c(as.character(x[-1]), final), levels = c(levels(x), final))
}

#' @export
#' @method from_to numeric
#' @rdname from_to
from_to.numeric <- function(x, final = 'End', ...){
    c(as.character(x[-1]), final)
}

#' @export
#' @method from_to data.frame
#' @rdname from_to
from_to.data.frame <- function(x, from.var, final = 'End', ...){

    data.table::data.table(data.frame(
        from = x[[from.var]],
        to = from_to(x[[from.var]]),
        x,
        stringsAsFactors = FALSE
    ))

}

#' Prepare Discourse Data for Network Plotting
#'
#' \code{from_to_summarize} - A wrapper for \code{from_to.data.frame} that
#' adds a \code{word.count} column and then combines duplicate rows.
#'
#' @rdname from_to
#' @export
from_to_summarize <- function(x, from.var, id.vars = NULL, text.var = TRUE,
    ...){

    word.count <- NULL

    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))
    if (!is.null(id.vars)) {
        w <- unique(z[, c(from.var, id.vars), with=FALSE])
    }

    text.var <- detect_text_column(x, text.var)

    express1 <- parse(
        text=paste0("word.count := stringi::stri_count_words(", text.var, ")")
    )

    z <- z[, eval(express1)][,
        'word.count' := ifelse(is.na(word.count), 0, word.count)][]

    out <- from_to(z, from.var)[,
        list(word.count = sum(word.count)), c('from', 'to')]

    if (!is.null(id.vars)) {
       out <- merge(out, w, all.x=TRUE, by.x = 'from', by.y = from.var)
    }

    out
}
