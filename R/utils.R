.mgsub <- function (pattern, replacement, text.var, fixed = TRUE,
	order.pattern = fixed, perl = !fixed, ...) {

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

is_numeric_doc_names <- function(x, ...){
    UseMethod('is_numeric_doc_names')
}


is_numeric_doc_names.TermDocumentMatrix <- function(x, ...){
    colnames_numeric <- suppressWarnings(as.integer(colnames(x)))
    !anyNA(colnames_numeric) && isTRUE(all.equal(stats::sd(diff(colnames_numeric)), 0))
}


is_numeric_doc_names.DocumentTermMatrix <- function(x, ...){
    rownames_numeric <- suppressWarnings(as.integer(rownames(x)))
    !anyNA(rownames_numeric) && isTRUE(all.equal(stats::sd(diff(rownames_numeric)), 0))
}
