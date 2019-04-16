## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(dplyr)
library(tidytransit)

## ------------------------------------------------------------------------
local_gtfs_path <- system.file("extdata", 
                               "google_transit_nyc_subway.zip", 
                               package = "tidytransit")
nyc <- read_gtfs(local_gtfs_path, 
                 local=TRUE,
                 geometry=TRUE,
                 frequency=TRUE)

## ------------------------------------------------------------------------
some_stops_freq_sf <- nyc$.$stops_sf %>%
  left_join(nyc$.$stops_frequency, by="stop_id") %>%
  select(headway)

## ------------------------------------------------------------------------
plot(some_stops_freq_sf)

## ------------------------------------------------------------------------
some_stops_freq_sf <- some_stops_freq_sf %>%
  filter(headway<60)
plot(some_stops_freq_sf)

## ------------------------------------------------------------------------
head(nyc$.$routes_frequency)

## ------------------------------------------------------------------------
nyc <- nyc %>% 
  set_hms_times() %>% 
  set_date_service_table()

## ------------------------------------------------------------------------
nyc <- nyc %>% 
  set_hms_times() %>% 
  set_date_service_table()

services_on_180823 <- nyc$.$date_service_table %>% 
  filter(date == "2018-08-23") %>% select(service_id)

## ------------------------------------------------------------------------
nyc <- get_route_frequency(nyc, service_id = services_on_180823, start_hour = 16, end_hour = 19)

## ------------------------------------------------------------------------
head(nyc$.$routes_frequency)

## ------------------------------------------------------------------------
routes_sf_frequencies <- nyc$.$routes_sf %>% 
  inner_join(nyc$.$routes_frequency, by = "route_id") %>% 
          select(route_id,
                 median_headways, 
                 mean_headways, 
                 st_dev_headways, 
                 stop_count)
plot(routes_sf_frequencies)

