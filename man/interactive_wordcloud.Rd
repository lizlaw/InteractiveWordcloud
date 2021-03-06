% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interactive_wordcloud.R
\name{interactive_wordcloud}
\alias{interactive_wordcloud}
\title{interactive_wordcloud}
\usage{
interactive_wordcloud(.minutes = 1, .freqsec = 5, ...)
}
\arguments{
\item{.minutes}{A number of minutes that the function will iterate for}

\item{.freqsec}{A number of seconds denoting the iteration frequency}

\item{...}{Further arguments passed to generate_wordcloud()}
}
\value{
A sequence of outputs from generate_wordcloud() (i.e. wordcloud plots or frequency tables)
}
\description{
Iterates generate_wordcloud() for live audience participation
}
\examples{
## Not run
# interactive_wordcloud(.minutes = 0.1, .freqsec = 1, size = 0.5)
}
