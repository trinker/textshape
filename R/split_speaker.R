#' Break and Stretch if Multiple Persons per Cell
#'
#' Look for cells with multiple people and create separate rows for each person.
#'
#' @param dataframe A dataframe that contains the person variable.
#' @param speaker.var The person variable to be stretched.
#' @param sep The separator(s) to search for and break on.  Default is:
#' c("and", "&", ",")
#' @param \ldots Ignored.
#' @return Returns an expanded dataframe with person variable stretched and
#' accompanying rows repeated.
#' @export
#' @examples
#' \dontrun{
#' DATA$person <- as.character(DATA$person)
#' DATA$person[c(1, 4, 6)] <- c("greg, sally, & sam",
#'     "greg, sally", "sam and sally")
#'
#' split_speaker(DATA)
#'
#' DATA$person[c(1, 4, 6)] <- c("greg_sally_sam",
#'     "greg.sally", "sam; sally")
#'
#' split_speaker(DATA, sep = c(".", "_", ";"))
#'
#' DATA <- textshape::DATA  #reset DATA
#' }
split_speaker <- function (dataframe, speaker.var = 1, sep = c("and", "&", ","),
    ...){

    element_id <- NULL
    nms <- colnames(dataframe)
    speaker.var <- colnames(dataframe[,speaker.var, drop=FALSE])
    z <- data.table::data.table(data.frame(dataframe, stringsAsFactors = FALSE))

    z[, element_id := 1:.N]
    express1 <- parse(text=
        paste0(
            speaker.var,
            " := list(splittify(",
            speaker.var,
            ", c(",
            paste(paste0("\"", sep, "\""), collapse=", "),
            ")))"
        )
    )

    z[, eval(express1)]

    express2 <- parse(text=paste0(".(", speaker.var, "=unlist(", speaker.var, "))"))
    z <- z[, eval(express2), by = c(colnames(z)[!colnames(z) %in% speaker.var])][, c(nms, "element_id"), with = FALSE]
    z[, 'split_id' := 1:.N, by = list(element_id)][]

}


splittify <- function(x, y) {

    y <- .mgsub(esc, paste0('\\', esc), y, perl = FALSE)

    lapply(x, function(z) {
        trimws(
            grep("^\\s*$",
                strsplit(as.character(z), paste(paste(y), collapse="|"))[[1]],
                value=TRUE,
                invert = TRUE
            )
        )
    })
}

esc <- c(".", "|", "(", ")", "[", "{", "^", "$", "*", "+", "?")
