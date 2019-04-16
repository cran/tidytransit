## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(tidytransit)
library(dplyr)

## ---- eval=FALSE---------------------------------------------------------
#  # Once sf is installed, you can install from CRAN with:
#  install.packages('tidytransit')
#  
#  # For the development version from Github:
#  # install.packages("devtools")
#  devtools::install_github("r-transit/tidytransit")

## ------------------------------------------------------------------------
# nyc <- read_gtfs("http://web.mta.info/developers/data/nyct/subway/google_transit.zip")

local_gtfs_path <- system.file("extdata", 
                               "google_transit_nyc_subway.zip", 
                               package = "tidytransit")
nyc <- read_gtfs(local_gtfs_path, 
                 local=TRUE)

## ------------------------------------------------------------------------
head(nyc$stops)

## ------------------------------------------------------------------------
names(nyc)

## ------------------------------------------------------------------------
head(feedlist)

## ---- eval=FALSE---------------------------------------------------------
#  nyc_ferries_gtfs <- feedlist %>%
#    filter(t=="NYC Ferry GTFS") %>%
#    pull(url_d) %>%
#    read_gtfs()

## ------------------------------------------------------------------------
library(sf)

feedlist_sf <- st_as_sf(feedlist,
                        coords=c("loc_lng","loc_lat"),
                        crs=4326)

plot(feedlist_sf, max.plot = 1)

## ------------------------------------------------------------------------
# Read in GTFS feed
# here we use a feed included in the package, but note that you can read directly from the New York City Metropolitan Transit Authority using the following URL:
# nyc <- read_gtfs("http://web.mta.info/developers/data/nyct/subway/google_transit.zip")
local_gtfs_path <- system.file("extdata", 
                               "google_transit_nyc_subway.zip", 
                               package = "tidytransit")
nyc <- read_gtfs(local_gtfs_path, 
                 local=TRUE,
                 geometry=TRUE,
                 frequency=TRUE)

## ------------------------------------------------------------------------
names(nyc$.)

## ------------------------------------------------------------------------
head(nyc$.$routes_frequency)

## ------------------------------------------------------------------------
head(nyc$.$stops_frequency)

## ------------------------------------------------------------------------
plot(nyc)

## ------------------------------------------------------------------------
validation_result <- attr(nyc, "validation_result")
head(validation_result)

