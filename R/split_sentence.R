#' Split Sentences
#'
#' Split sentences.
#'
#' @param x A \code{\link[base]{data.frame}} or character vector with sentences.
#' @param text.var The name of the text variable.  If \code{TRUE}
#' \code{split_sentence} tries to detect the column with sentences.
#' @param \ldots Ignored.
#' @export
#' @rdname split_sentence
#' @importFrom data.table .N :=
#' @return Returns a list of vectors of sentences or a expanded
#' \code{\link[base]{data.frame}} with sentences split apart.
#' @examples
#' (x <- c(paste0(
#'     "Mr. Brown comes! He says hello. i give him coffee.  i will ",
#'     "go at 5 p. m. eastern time.  Or somewhere in between!go there"
#' ),
#' paste0(
#'     "Marvin K. Mooney Will You Please Go Now!", "The time has come.",
#'     "The time has come. The time is now. Just go. Go. GO!",
#'     "I don't care how."
#' )))
#' split_sentence(x)
#'
#' data(DATA)
#' split_sentence(DATA)
#'
#' \dontrun{
#' ## Kevin S. Dias' sentence boundary disambiguation test set
#' data(golden_rules)
#' library(magrittr)
#'
#' golden_rules %$%
#'     split_sentence(Text)
#' }
split_sentence <- function(x, ...) {
    UseMethod("split_sentence")
}

#' @export
#' @rdname split_sentence
#' @method split_sentence default
split_sentence.default <- function(x, ...) {
    get_sents2(x)
}

#' @export
#' @rdname split_sentence
#' @method split_sentence data.frame
split_sentence.data.frame <- function(x, text.var = TRUE, ...) {

    element_id <- NULL
    nms <- colnames(x)
    z <- data.table::data.table(data.frame(x, stringsAsFactors = FALSE))

    if (isTRUE(text.var)) {
        text.var <- names(which.max(sapply(as.data.frame(z), function(y) {
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)), na.rm = TRUE)
        }))[1])
        if (length(text.var) == 0) stop("Could not detect `text.var`.  Please supply `text.var` explicitly.")
    }

    z[, element_id := 1:.N]
    express1 <- parse(text=paste0(text.var, " := list(get_sents2(", text.var, "))"))
    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", text.var, "=unlist(", text.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% text.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'sentence_id' := 1:.N, by = list(element_id)][]

}





#get_sents <- function(x) {
#    x <- stringi::stri_replace_all_regex(stringi::stri_trans_tolower(x), sent_regex, "")
#    stringi::stri_split_regex(x, "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?|\\!)\\s")
#}


abbr_rep_1 <- lapply(list(
    Titles   = c('mr', 'mrs', 'ms', 'dr', 'prof', 'sen', 'rep',
                 'rev', 'gov', 'atty', 'supt', 'det', 'rev', 'col','gen', 'lt',
                 'cmdr', 'adm', 'capt', 'sgt', 'cpl', 'maj'),

    Entities = c('dept', 'univ', 'uni', 'assn'),

    Misc     = c('vs', 'mt'),

    Streets  = c('st')
), function(x){
    fl <- sub("(^[a-z])(.+)", "\\1", x)
    sprintf("[%s%s]%s", fl, toupper(fl), sub("(^[a-z])(.+)", "\\2", x))
})

abbr_rep_2 <- lapply(list(
    Titles      = c('jr', 'sr'),

    Entities    = c('bros', 'inc', 'ltd', 'co', 'corp', 'plc'),

    Months      = c('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul',
                    'aug', 'sep', 'oct', 'nov', 'dec', 'sept'),

    Days        = c('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'),

    Misc        = c('etc', 'esp', 'cf', 'al'),

    Streets     = c('ave', 'bld', 'blvd', 'cl', 'ct', 'cres', 'rd'),

    ## measures from:http://englishplus.com/grammar/00000058.htm
    ## excluded b/c likely to overlap with actual words: {'in', 'oz'}
    Measurement = c('ft', 'gal', 'mi', 'tbsp', 'tsp', 'yd', 'qt',
                    'sq', 'pt', 'lb', 'lbs')
), function(x){
    fl <- sub("(^[a-z])(.+)", "\\1", x)
    sprintf("[%s%s]%s", fl, toupper(fl), sub("(^[a-z])(.+)", "\\2", x))
})


period_reg <- paste0(
    "(?:(?<=[a-z])\\.\\s(?=[a-z]\\.))",
        "|",
    "(?:(?<=([ .][a-z]))\\.)(?!(?:\\s[A-Z]|$)|(?:\\s\\s))",
        "|",
    "(?:(?<=[A-Z])\\.(?=\\s??[A-Z]\\.))",
        "|",
    "(?:(?<=[A-Z])\\.(?!\\s+[A-Z][A-Za-z]))"
)

# gsub("(((?<=\\b(%s))\\.)(\\s+(?![A-Z])))", '[[[]]]',
#     'With the co. in hand they were Co. parts in co. I want', perl=TRUE)

## there are 2 sets of abbreviation lists abbr_rep_1 & abbr_rep_2.  This is
## because the first set will likely have a proper noun following them (e.g.
## Dr. Rinker) while the latter will not and if they are followed by a capital
## letter then the abbreviation likely ends the sentence and a split should
## occur there.  This is baked into the replacement logic for splitting.
sent_regex <- sprintf("((?<=\\b(%s))\\.)|((?<=\\b(%s))\\.(?!\\s+[A-Z]))|%s|(%s)",
    paste(unlist(abbr_rep_1), collapse = "|"),
    paste(unlist(abbr_rep_2), collapse = "|"),
    period_reg,
	'\\.(?=\\d+)'
)


get_sents2 <- function(x) {

    y <- stringi::stri_replace_all_regex(trimws(x), '([Pp])(\\.)(\\s*[Ss])(\\.)', '$1<<<TEMP>>>$3<<<TEMP>>>')
    y <- stringi::stri_replace_all_regex(y, sent_regex, "<<<TEMP>>>")
    y <- stringi::stri_replace_all_regex(y, '(\\b[Nn]o)(\\.)(\\s+\\d)', '$1<<<TEMP>>>$3')
    y <- stringi::stri_replace_all_regex(y, '(\\b\\d+\\s+in)(\\.)(\\s[a-z])', '$1<<<TEMP>>>$3')
    y <- stringi::stri_replace_all_regex(y, '([?.!]+)([\'])([^,])', '<<<SQUOTE>>>$1  $3')
    y <- stringi::stri_replace_all_regex(y, '([?.!]+)(["])([^,])', '<<<DQUOTE>>>$1  $3')
    ## midde name handling
    y <- stringi::stri_replace_all_regex(y,
        '(\\b[A-Z][a-z]+\\s[A-Z])(\\.)(\\s[A-Z][a-z]+\\b)',
        '$1<<<TEMP>>>$3'
    )

    #2 middle names
    y <- stringi::stri_replace_all_regex(y,
        '(\\b[A-Z][a-z]+\\s[A-Z])(\\.)(\\s[A-Z])(\\.)(\\s[A-Z][a-z]+\\b)',
        '$1<<<TEMP>>>$3<<<TEMP>>>$5'
    )
    y <- stringi::stri_split_regex(y, "((?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?|\\!)(\\s|(?=[a-zA-Z][a-zA-Z]*\\s)))|(?<=[A-Z][a-z][.?!])\\s+")



    lens <- cumsum(lengths(y)) + 1
    locs <- lens[seq_len(length(lens) - 1)]

    y <- trimws(unlist(y))

    y <- stringi::stri_replace_all_fixed(y, "<<<TEMP>>>", ".")
    y <- stringi::stri_replace_all_regex(y, "(<<<DQUOTE>>>)([?.!]+)", "$2\"")
    y <- stringi::stri_replace_all_regex(y, "(<<<SQUOTE>>>)([?.!]+)", "$2'")

    split_index(y, locs)
}

get_sentences2 <- function(x, ...) {
    lapply(lapply(get_sents2(trimws(x)), function(x) gsub("<<<TEMP>>>", ".", x)),
        function(x) gsub("^\\s+|\\s+$", "", x))
}


