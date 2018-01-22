#' Flatten a Nested List of Vectors Into a Single Tier List of Vectors
#'
#' Flatten a named, nested list of atomic vectors to a single level using the
#' concatenated list/atomic vector names as the names of the single tiered
#' list.
#'
#' @param x A nested, named list of vectors.
#' @param sep A separator to use for the concatenation of the names from the
#' nested list.
#' @param \ldots ignored.
#' @return Returns a flattened list.
#' @author StackOverflow user @@Michael and Paul Foster and Tyler Rinker <tyler.rinker@@gmail.com>.
#' @export
#' @note The order of the list is sorted alphabetically.  Pull requests for the
#' option to return the original order would be appreciated.
#' @references \url{https://stackoverflow.com/a/41882883/1000343} \cr
#' \url{https://stackoverflow.com/a/48357114/1000343}
#' @examples
#' x <- list(
#'     urban = list(
#'         cars = c('volvo', 'ford'),
#'         food.dining = list(
#'             local.business = c('carls'),
#'             chain.business = c('dennys', 'panera')
#'         )
#'     ),
#'     rural = list(
#'         land.use = list(
#'             farming =list(
#'                 dairy = c('cows'),
#'                 vegie.plan = c('carrots')
#'             )
#'         ),
#'         social.rec = list(
#'             community.center = c('town.square')
#'         ),
#'         people.type = c('good', 'bad', 'in.between')
#'     ),
#'     other.locales = c('suburban'),
#'     missing = list(
#'         unknown = c(),
#'         known = c()
#'     ),
#'     end = c('wow')
#' )
#'
#' x
#'
#' flatten(x)
#' flatten(x, ' -> ')
#'
#' \dontrun{
#' ## dictionary from quanteda
#' require(quanteda); library(textreadr); library(dplyr)
#' mydict <- textreadr::download("https://provalisresearch.com/Download/LaverGarry.zip") %>%
#'     unzip(exdir = (td <- tempdir())) %>%
#'     `[`(1) %>%
#'     quanteda::dictionary(file = .)
#'
#' mydict
#' flatten(as.list(mydict))
#' }
flatten <- function(x , sep = '_', ...){

    stopifnot(is.list(x))

    x <- fix_names(x)

    out<- flatten_h(x)

    names(out) <- gsub('\\.', sep, names(out))

    names(out) <- gsub('unlikelystringtodupe', '.', names(out), fixed = TRUE)

    out[order(names(out))]

}

flatten_h <- function(x){

    z <- unlist(lapply(x, function(y) class(y)[1] == "list"))

    out <- c(x[!z], unlist(x[z], recursive=FALSE))

    if (sum(z)){
        Recall(out)
    } else {
        out
    }
}

fix_names <- function(x) {

    if (is.list(x)) {
        names(x) <- gsub('\\.', 'unlikelystringtodupe', names(x))
        lapply(x, fix_names)
    } else {

        x
    }
}


# fix_names <- function(x) UseMethod('fix_names')
#
# fix_names.list <- function(x) {
#   names(x) <- gsub('\\.', 'unlikelystringtodupe', names(x))
#   lapply(x, fix_names)
# }
#
# fix_names.default <- function(x) x



