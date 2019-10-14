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
nyc <- read_gtfs(local_gtfs_path)

## ------------------------------------------------------------------------
summary(nyc)

## ------------------------------------------------------------------------
head(nyc$stops)

## ------------------------------------------------------------------------
names(nyc)

## ------------------------------------------------------------------------
validation_result <- attr(nyc, "validation_result")
head(validation_result)

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

