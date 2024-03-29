% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flatten.R
\name{flatten}
\alias{flatten}
\title{Flatten a Nested List of Vectors Into a Single Tier List of Vectors}
\usage{
flatten(x, sep = "_", ...)
}
\arguments{
\item{x}{A nested, named list of vectors.}

\item{sep}{A separator to use for the concatenation of the names from the
nested list.}

\item{\ldots}{ignored.}
}
\value{
Returns a flattened list.
}
\description{
Flatten a named, nested list of atomic vectors to a single level using the
concatenated list/atomic vector names as the names of the single tiered
list.
}
\note{
The order of the list is sorted alphabetically.  Pull requests for the
option to return the original order would be appreciated.
}
\examples{
x <- list(
    urban = list(
        cars = c('volvo', 'ford'),
        food.dining = list(
            local.business = c('carls'),
            chain.business = c('dennys', 'panera')
        )
    ),
    rural = list(
        land.use = list(
            farming =list(
                dairy = c('cows'),
                vegie.plan = c('carrots')
            )
        ),
        social.rec = list(
            community.center = c('town.square')
        ),
        people.type = c('good', 'bad', 'in.between')
    ),
    other.locales = c('suburban'),
    missing = list(
        unknown = c(),
        known = c()
    ),
    end = c('wow')
)

x

flatten(x)
flatten(x, ' -> ')
}
\references{
\url{https://stackoverflow.com/a/41882883/1000343} \cr
\url{https://stackoverflow.com/a/48357114/1000343}
}
\author{
StackOverflow user @Michael and Paul Foster and Tyler
Rinker <tyler.rinker@gmail.com>.
}
