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
    "(?:(?<=[A-Z])\\.(?!\\s+[A-Z][A-Za-z]))"
)


sent_regex <- sprintf("((?<=\\b(%s))\\.)|%s|(%s)",
    paste(unlist(abbr_rep), collapse = "|"),
    period_reg,
	'\\.(?=\\d+)'
)


get_sents2 <- function(x) {
    y <- stringi::stri_replace_all_regex(trimws(x), sent_regex, "<<<TEMP>>>")
    stringi::stri_split_regex(y, "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?|\\!)(\\s|(?=[a-zA-Z][a-zA-Z]*\\s))")
}

get_sentences2 <- function(x, ...) {
    lapply(lapply(get_sents2(trimws(x)), function(x) gsub("<<<TEMP>>>", ".", x)),
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



paste2 <- function (multi.columns, sep = ".", handle.na = TRUE, trim = TRUE) {
    if (is.matrix(multi.columns)) {
        multi.columns <- data.frame(multi.columns, stringsAsFactors = FALSE)
    }
    if (trim)
        multi.columns <- lapply(multi.columns, function(x) {
            gsub("^\\s+|\\s+$", "", x)
        })
    if (!is.data.frame(multi.columns) & is.list(multi.columns)) {
        multi.columns <- do.call("cbind", multi.columns)
    }
    if (handle.na) {
        m <- apply(multi.columns, 1, function(x) {
            if (any(is.na(x))) {
                NA
            } else {
                paste(x, collapse = sep)
            }
        })
    } else {
        m <- apply(multi.columns, 1, paste, collapse = sep)
    }
    names(m) <- NULL
    return(m)
}

is.Integer <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol

pad <- function (x, padding = max(nchar(as.character(x))), sort = TRUE,
    type = "detect") {
    poss <- c("detect", "numeric", "character", "d", "s")
    if (!type %in% poss)
        stop("type must be: \"detect\", \"numeric\"\\\"d\" or \"character\"\\\"s\"")
    Rel <- c(NA, "d", "s", "d", "s")
    type <- Rel[poss %in% type]
    if (is.na(type)) {
        type <- ifelse(is.numeric(x), "d", "s")
    }
    x <- sprintf_ish(x, padding, type)
    if (sort) {
        x <- sort(x)
    }
    x
}

sprintf_ish <- function(x, padding, type){
    OS <- Sys.info()[['sysname']]

    if (OS %in% c("Windows", "Linux")) {
        sprintf(paste0("%0", padding, type), x)
    } else {
        type <- ifelse(type == "s", " ", "0")
        pads <- sapply(padding - nchar(x), function(i)  {
            if (i == 0) return("")
            paste(rep(type, i), collapse = "")
        })
        paste0(pads, x)

    }
}

# ## check if dplyr is loaded (used in tibble_output function)
# is_dplyr_loaded <- function() 'dplyr' %in% names(utils::sessionInfo()[["otherPkgs"]])
#
# ## convert a data.table to tibble
# set_tibble <- function(x, ...){
#     stopifnot(is.data.frame(x))
#     class(x) <- c("tbl_df", "tbl", "data.frame")
#     x
# }
#
# if_tibble <- function(x, as.tibble, ...){
#     if(!isTRUE(as.tibble)) return(x)
#     set_tibble(x)
# }

