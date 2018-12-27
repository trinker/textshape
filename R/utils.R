.mgsub <- function (pattern, replacement, text.var, fixed = TRUE,
	order.pattern = fixed, perl = !fixed, ...) {

    if (fixed && order.pattern) {
        ord <- rev(order(nchar(pattern)))
        pattern <- pattern[ord]
        if (length(replacement) != 1) replacement <- replacement[ord]
    }
    
    if (length(replacement) == 1) {
        replacement <- rep(replacement, length(pattern))
    }

    for (i in seq_along(pattern)){
        text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, 
            perl = perl, ...)
    }

    text.var
}


nth <- function(x, ...){
    if (is.null(x)) return(1)
    if (is.numeric(x)) x <- as.integer(x)
    if (is.integer(x) && x < 1) stop('`from.n` and `to.n` must be > 1')
    if (is.integer(x)) return(x)
    if (is.character(x)) {
        switch(x,
            first = 1,
            last =,
            n = Inf,
            stop('If supplying a string to `from.n` or `to.n` must be one of: c("first", "last", or "n")')
        )
    }
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
    unlist(lapply(seq_len(nrow(mat)), function(i) {
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
    
    if (!type %in% poss){
        stop(
            paste(
                "type must be: \"detect\",", 
                "\"numeric\"\\\"d\" or \"character\"\\\"s\""
            ), 
            call. = FALSE
        )
    }
    
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
        pads <- sapply2(padding - nchar(x), function(i)  {
            if (i == 0) return("")
            paste(rep(type, i), collapse = "")
        })
        paste0(pads, x)

    }
}


is_numeric_doc_names <- function(x, ...){
    UseMethod('is_numeric_doc_names')
}


is_numeric_doc_names.TermDocumentMatrix <- function(x, ...){
    colnames_numeric <- suppressWarnings(as.integer(colnames(x)))
    !anyNA(colnames_numeric) && 
        isTRUE(all.equal(stats::sd(diff(colnames_numeric)), 0))
}


is_numeric_doc_names.DocumentTermMatrix <- function(x, ...){
    rownames_numeric <- suppressWarnings(as.integer(rownames(x)))
    !anyNA(rownames_numeric) && 
        isTRUE(all.equal(stats::sd(diff(rownames_numeric)), 0))
}

## function to detect text columns
detect_text_column <- function(dat, text.var){
    
    if (isTRUE(text.var)) {
    
        dat <- as.data.frame(dat, stringsAsFactors = FALSE)
        
        mean_lens <- unlist(lapply(dat, function(y) {
         
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)), na.rm = TRUE)
            
        }))
    
        max_cols <- which.max(mean_lens)
        
        text.var <- colnames(dat)[max_cols[1]]
        
        if (length(text.var) == 0 | sum(as.integer(mean_lens)) == 0) {
            stop(
                paste(
                    "Could not detect ` text.var`.", 
                    "Please supply `text.var` explicitly."
                ),
                call. = FALSE
            )
        }
        
        if (length(max_cols) > 1) {
            warning(
                sprintf(
                    'More than one text column detected...using `%s`', 
                    text.var
                ), 
                call. = FALSE
            )    
        }
    } 
    
    text.var
    
}


sapply2 <- function (X, FUN, ...) {
    unlist(lapply(X, FUN, ...))
}


