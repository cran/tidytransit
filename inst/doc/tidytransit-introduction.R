## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  # Once sf is installed, you can install from CRAN with:
#  install.packages('tidytransit')
#  
#  # For the development version from Github:
#  # install.packages("devtools")
#  devtools::install_github("r-transit/tidytransit")

## ------------------------------------------------------------------------
library(tidytransit)
library(dplyr)

# Read in GTFS feed
# here we use a feed included in the package, but note that you can read directly from the New York City Metropolitan Transit Authority using the following URL:
#nyc <- read_gtfs("http://web.mta.info/developers/data/nyct/subway/google_transit.zip")

local_gtfs_path <- system.file("extdata", 
                               "google_transit_nyc_subway.zip", 
                               package = "tidytransit")
nyc <- read_gtfs(local_gtfs_path, 
                   local=TRUE)


# Get route frequencies
nyc_route_freqs <- nyc %>% 
  get_route_frequency()

# Find routes with shortest median headways
nyc_fastest_routes <- nyc_route_freqs %>% 
  filter(median_headways < 25) %>% 
  arrange(median_headways)

knitr::kable(head(nyc_fastest_routes))

## ------------------------------------------------------------------------
nyc_stop_freqs <- nyc %>% 
  get_stop_frequency(by_route = FALSE) %>%
  inner_join(nyc$stops_df, by = "stop_id") %>%
  select(stop_name, direction_id, stop_id, headway) %>%
  arrange(headway)

head(nyc_stop_freqs)

## ------------------------------------------------------------------------
routes_sf_frequencies <- nyc$routes_sf %>% 
  inner_join(nyc_fastest_routes, by = "route_id") %>% 
  select(median_headways, 
         mean_headways, 
         st_dev_headways, 
         stop_count)

plot(routes_sf_frequencies)

