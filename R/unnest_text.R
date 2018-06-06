#' Un-nest Nested Text Columns
#' 
#' Un-nest nested text columns in a data.frame.   Attempts to locate the nested 
#' text column without specifying. 
#' 
#' @param dataframe A dataframe object.
#' @param column Column name to search for markers/terms. 
#' @param integer.rownames logical.  If \code{TRUE} then the rownames are 
#' numbered 1 through number of rows, otherwise the original row number is 
#' retained followed by a period and the element number from the list.
#' @param \ldots ignored.
#' @return Returns an un-nested data.frame.
#' @export
#' @examples
#' dat <- DATA
#' 
#' ## Add a nested/list text column
#' dat$split <- lapply(dat$state, function(x) {
#'     unlist(strsplit(x, '(?<=[?!.])\\s+', perl = TRUE))
#' })
#' 
#' unnest_text(dat)
#' unnest_text(dat, integer.rownames = FALSE)
#' 
#' ## Add a second nested integer column
#' dat$d <- lapply(dat$split, nchar)
#' \dontrun{
#' unnest_text(dat) # causes error, must supply column explicitly
#' }
#' unnest_text(dat, 'split')
#' 
#' ## As a data.table
#' library(data.table)
#' dt_dat <- data.table::as.data.table(data.table::copy(dat))
#' unnest_text(dt_dat, 'split')
#' \dontrun{
#' unnest_text(dt_dat, 'd')
#' }
#' 
#' \dontrun{
#' ## As a tibble
#' library(tibble)
#' t_dat <- tibble:::as_tibble(dat)
#' unnest_text(t_dat, 'split')
#' }
unnest_text <- function(dataframe, column, integer.rownames = TRUE, ...){

    if (missing(column)) {
        
        column <- names(dataframe)[!unlist(lapply(as.data.frame(dataframe), 
            is.atomic))]
        if (length(column) == 0) {
            stop(paste(
                "There appears to be no nested columns.", 
                "Please supply `column` explicitly."
            ), call. = FALSE)
        }
        
        if (length(column) > 1) {
            stop(paste(
                "There appears to be multiple nested columns.", 
                "Please supply `column` explicitly."
            ), call. = FALSE)
        }
        message(sprintf('Nested column detected, un-nesting: %s', column))
        
    }

    nms <- colnames(dataframe)
    
    lens <- lengths(dataframe[[column]])
    col <- unlist(dataframe[[column]])

    if (!is.character(col)) {
        warning(
            sprintf(
                paste0(
                    'Un-nesting: `%s`\nThis is not a character column.\n\n', 
                    'Perhaps you want to use `tidyr::unnest` instead?'
                ), 
                column
            ), 
            call. = FALSE
        )
    }
    
    dataframe[[column]] <- NA
    
    dataframe <- dataframe[rep(seq_len(nrow(dataframe)), lens),]
    
    dataframe[[column]] <- col
    if (isTRUE(integer.rownames)) {
        rownames(dataframe) <- NULL
    } else {
        rnms <- rownames(dataframe)
        rnms <- ifelse(grepl('\\.', rnms), rnms, paste0(rnms, '.0'))
        
        rownames(dataframe) <- paste0(
            gsub('\\.+$', '', rnms),
            '.',    
            as.integer(gsub('^\\d+\\.', '', rnms)) + 1
        )
    }
    
    dataframe

}

