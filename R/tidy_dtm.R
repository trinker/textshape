#' Convert a \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}}
#' into Tidy Form
#'
#' Converts non-zero elements of a
#' \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}} into
#' a tidy data set.
#'
#'
#' @param x A \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}}.
#' @param \ldots ignored.
#' @return Returns a tidied data.frame.
#' @rdname tidy_dtm
#' @export
#' @examples
#' data(simple_dtm)
#'
#' tidy_dtm(simple_dtm)
#'
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load_current_gh('trinker/gofastr')
#' pacman::p_load(tidyverse, magrittr, ggstance)
#'
#' my_dtm <- with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_")))
#'
#' tidy_dtm(my_dtm) %>%
#'     tidyr::extract(doc, c("time", "turn", "sentence"), "(\\d)_(\\d+)\\.(\\d+)") %>%
#'     mutate(
#'         time = as.numeric(time),
#'         turn = as.numeric(turn),
#'         sentence = as.numeric(sentence)
#'     ) %>%
#'     tbl_df() %T>%
#'     print() %>%
#'     group_by(time, term) %>%
#'     summarize(n = sum(n)) %>%
#'     group_by(time) %>%
#'     arrange(desc(n)) %>%
#'     slice(1:10) %>%
#'     mutate(
#'         term = factor(paste(term, time, sep = "__"),
#'             levels = rev(paste(term, time, sep = "__")))
#'     ) %>%
#'     ggplot(aes(x = n, y = term)) +
#'         geom_barh(stat='identity') +
#'         facet_wrap(~time, ncol=2, scales = 'free_y') +
#'         scale_y_discrete(labels = function(x) gsub("__.+$", "", x))
#' }
tidy_dtm <- function(x, ...){

    doc <- NULL

    data.table::data.table(
        doc = x[['dimnames']][['Docs']][x[['i']]],
        term = x[['dimnames']][['Terms']][x[['j']]],
        n = x[['v']],
        i = x[['i']],
        j = x[['j']]
    )[order(doc), ]
}



#' @rdname tidy_dtm
#' @export
tidy_tdm <- function(x, ...){

    doc <- NULL

    out <- data.table::data.table(
        doc = x[['dimnames']][['Docs']][x[['j']]],
        term = x[['dimnames']][['Terms']][x[['i']]],
        n = x[['v']],
        i = x[['j']],
        j = x[['i']]
    )[order(doc), ]
}
