## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ---- message=FALSE, warning=FALSE, results='hide'-----------------------
library(tidytransit)
library(dplyr)

## ---- message=FALSE, warning=FALSE, results='hide'-----------------------
local_gtfs_path <- system.file("extdata", "google_transit_nyc_subway.zip", package = "tidytransit")
NYC <- import_gtfs(local_gtfs_path, local=TRUE)

## ---- message=FALSE, warning=FALSE, results='hide', eval=FALSE-----------
#  NYC <- import_gtfs("http://web.mta.info/developers/data/nyct/subway/google_transit.zip")

## ------------------------------------------------------------------------
route_frequency_summary <- route_frequency(NYC) %>%
  arrange(median_headways)

fast_routes <- filter(route_frequency_summary, median_headways<25)

knitr::kable(head(fast_routes))

## ------------------------------------------------------------------------
stop_frequency_summary <- stop_frequency(NYC, by_route=FALSE) %>%
  inner_join(NYC$stops_df, by="stop_id") %>%
    select(stop_name, direction_id, stop_id, headway) %>%
      arrange(headway)

head(stop_frequency_summary)

## ------------------------------------------------------------------------
print(names(NYC))

## ------------------------------------------------------------------------
NYC <- gtfs_as_sf(NYC)

## ------------------------------------------------------------------------
print(names(NYC))

## ----plot1---------------------------------------------------------------
routes_headways_sf <- right_join(NYC$sf_routes,fast_routes, by="route_id")
routes_headways_sf_vars_only <- select(routes_headways_sf,-route_id)

plot(routes_headways_sf_vars_only)

