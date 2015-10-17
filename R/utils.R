.mgsub <- function (pattern, replacement, text.var, fixed = TRUE,
	order.pattern = fixed, perl = TRUE, ...) {

    if (fixed && order.pattern) {
        ord <- rev(order(nchar(pattern)))
        pattern <- pattern[ord]
        if (length(replacement) != 1) replacement <- replacement[ord]
    }
    if (length(replacement) == 1) replacement <- rep(replacement, length(pattern))

    for (i in seq_along(pattern)){
        text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, perl = perl, ...)
    }

    text.var
}



mark_start <- function(class){
    sprintf("<mark class=\"%s\">", class)
}

mark_end <- "</mark>"



#get_sents <- function(x) {
#    x <- stringi::stri_replace_all_regex(stringi::stri_trans_tolower(x), sent_regex, "")
#    stringi::stri_split_regex(x, "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?|\\!)\\s")
#}
abbr_rep <- lapply(list(
  Titles   = c('jr', 'mr', 'mrs', 'ms', 'dr', 'prof', 'sr', 'sen', 'rep',
         'rev', 'gov', 'atty', 'supt', 'det', 'rev', 'col','gen', 'lt',
         'cmdr', 'adm', 'capt', 'sgt', 'cpl', 'maj'),

  Entities = c('dept', 'univ', 'uni', 'assn', 'bros', 'inc', 'ltd', 'co',
         'corp', 'plc'),

  Months   = c('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul',
         'aug', 'sep', 'oct', 'nov', 'dec', 'sept'),

  Days     = c('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'),

  Misc     = c('vs', 'etc', 'no', 'esp', 'cf', 'al', 'mt'),

  Streets  = c('ave', 'bld', 'blvd', 'cl', 'ct', 'cres', 'dr', 'rd', 'st')
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
    "(?:(?<=[A-Z])\\.(?!\\s[A-Z][A-Za-z]))"
)


sent_regex <- sprintf("((?<=\\b(%s))\\.)|%s|(%s)",
    paste(unlist(abbr_rep), collapse = "|"),
    period_reg,
	'\\.(?=\\d+)'
)


get_sents2 <- function(x) {
    y <- stringi::stri_replace_all_regex(x, sent_regex, "<<<TEMP>>>")
    stringi::stri_split_regex(y, "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?|\\!)(\\s|(?=[a-zA-Z][a-zA-Z]*\\s))")
}

get_sentences2 <- function(x, ...) {
    lapply(lapply(get_sents2(x), function(x) gsub("<<<TEMP>>>", ".", x)),
        function(x) gsub("^\\s+|\\s+$", "", x))
}

add_row_id <- function(x){
    lens <- lapply(x, length)
    rep(seq_along(lens), unlist(lens))
}

title_tag_table <- function (mat) {
    unlist(lapply(1:nrow(mat), function(i) {
        x <- unlist(mat[i, , drop = FALSE])
        names(x[x > 0][1])
    }))
}
