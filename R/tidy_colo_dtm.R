#' Convert a \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}} into Collocating Words in Tidy Form
#'
#' Converts non-zero elements of a
#' \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}} into
#' a tidy data set made of collocating words.
#'
#' @param x A \code{\link[tm]{DocumentTermMatrix}}/\code{\link[tm]{TermDocumentMatrix}}.
#' @param as.tibble logical.  If \code{TRUE} the output class will be set to a
#' \pkg{tibble}, otherwise a \code{\link[data.table]{data.table}}.  Default
#' checks \code{getOption("tibble.out")} as a logical.  If this is \code{NULL}
#' the default \code{\link[textshape]{tibble_output}} will set \code{as.tibble}
#' to \code{TRUE} if \pkg{dplyr} is loaded.  Otherwise, the output will be a
#' \code{\link[data.table]{data.table}}.
#' @param \ldots Ignored.
#' @return Returns a tidied data.frame.
#' @rdname tidy_colo_dtm
#' @export
#' @seealso \code{\link[textshape]{unique_pairs}}
#' @examples
#' data(simple_dtm)
#'
#' tidied <- tidy_colo_dtm(simple_dtm)
#' tidied
#' unique_pairs(tidied)
#'
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load_current_gh('trinker/gofastr', 'trinker/lexicon')
#' pacman::p_load(tidyverse, magrittr, ggstance)
#'
#' my_dtm <- with(presidential_debates_2012, q_dtm(dialogue, paste(time, tot, sep = "_")))
#'
#' tidy_colo_dtm(my_dtm) %>%
#'     tbl_df() %>%
#'     filter(!term_1 %in% c('i', lexicon::sw_onix) & !term_2 %in% lexicon::sw_onix) %>%
#'     filter(term_1 != term_2) %>%
#'     unique_pairs() %>%
#'     filter(n > 15) %>%
#'     complete(term_1, term_2, fill = list(n = 0)) %>%
#'     ggplot(aes(x = term_1, y = term_2, fill = n)) +
#'         geom_tile() +
#'         scale_fill_gradient(low= 'white', high = 'red') +
#'         theme(axis.text.x = element_text(angle = 45, hjust = 1))
#' }
tidy_colo_tdm <- function(x, as.tibble = tibble_output(), ...){

    term_1 <- NULL

    x <- slam::as.simple_triplet_matrix(slam::tcrossprod_simple_triplet_matrix(x, y = NULL))

    if_tibble(
        data.table::data.table(
            term_1 = x[['dimnames']][['Terms']][x[['i']]],
            term_2 = x[['dimnames']][['Terms']][x[['j']]],
            n = x[['v']]
        )[order(term_1), ],
        as.tibble = as.tibble
    )
}



#' @rdname tidy_colo_dtm
#' @export
tidy_colo_dtm <- function(x, as.tibble = tibble_output(), ...){

    term_1 <- NULL

    x <- slam::as.simple_triplet_matrix(slam::crossprod_simple_triplet_matrix(x, y = NULL))

    if_tibble(
        data.table::data.table(
            term_1 = x[['dimnames']][['Terms']][x[['i']]],
            term_2 = x[['dimnames']][['Terms']][x[['j']]],
            n = x[['v']]
        )[order(term_1), ],
        as.tibble = as.tibble
    )
}


