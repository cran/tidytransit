% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.R
\name{print.tidygtfs}
\alias{print.tidygtfs}
\title{Print a GTFS object}
\usage{
\method{print}{tidygtfs}(x, ...)
}
\arguments{
\item{x}{A GTFS object.}

\item{...}{Optional arguments ultimately passed to \code{format}.}
}
\value{
The GTFS object that was printed, invisibly
}
\description{
Prints a GTFS object suppressing the \code{class} attribute.
}
\examples{
 \dontrun{
path = system.file("extdata", 
           "google_transit_nyc_subway.zip", 
           package = "tidytransit")

g = read_gtfs(path)
print(g)
}
}
