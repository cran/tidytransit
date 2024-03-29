% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/service.R
\name{set_servicepattern}
\alias{set_servicepattern}
\title{Calculate servicepattern ids for a gtfs feed}
\usage{
set_servicepattern(
  gtfs_obj,
  id_prefix = "s_",
  hash_algo = "md5",
  hash_length = 7
)
}
\arguments{
\item{gtfs_obj}{gtfs feed (tidygtfs object)}

\item{id_prefix}{all servicepattern id will start with this string}

\item{hash_algo}{hashing algorithm used by digest}

\item{hash_length}{length the hash should be cut to with substr(). Use -1 if the full hash should be used}
}
\value{
modified gtfs_obj with added servicepattern list and a table linking
trips and pattern (trip_servicepatterns)
}
\description{
Each trip has a defined number of dates it runs on. This set of dates is called a
service pattern in tidytransit. Trips with the same servicepattern id run on the same
dates. In general, \code{service_id} can work this way but it is not enforced by the
GTFS standard.
}
