% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frequencies.R
\name{get_stop_frequency}
\alias{get_stop_frequency}
\title{Get Stop Frequency}
\usage{
get_stop_frequency(
  gtfs_obj,
  start_time = "06:00:00",
  end_time = "22:00:00",
  service_ids = NULL,
  by_route = TRUE
)
}
\arguments{
\item{gtfs_obj}{gtfs feed (tidygtfs object)}

\item{start_time}{analysis start time, can be given as "HH:MM:SS",
hms object or numeric value in seconds.}

\item{end_time}{analysis period end time, can be given as "HH:MM:SS",
hms object or numeric value in seconds.}

\item{service_ids}{A set of service_ids from the calendar dataframe
identifying a particular service id. If not provided, the service_id
with the most departures is used.}

\item{by_route}{Default TRUE, if FALSE then calculate headway for any line coming
through the stop in the same direction on the same schedule.}
}
\value{
dataframe of stops with the number of departures and the headway
(departures divided by timespan) in seconds as columns
}
\description{
Calculate the number of departures and mean headways for all stops within a
given timespan and for given service_ids.
}
\note{
Some GTFS feeds contain a frequency data frame already.
Consider using this instead, as it will be more accurate than what
tidytransit calculates.
}
\examples{
data(gtfs_duke)
stop_frequency <- get_stop_frequency(gtfs_duke)
x <- order(stop_frequency$mean_headway)
head(stop_frequency[x,])
}
