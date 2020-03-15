## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(dplyr)
library(tidytransit)
library(ggplot2)
library(sf)

## ------------------------------------------------------------------------
local_gtfs_path <- system.file("extdata", "google_transit_nyc_subway.zip", package = "tidytransit")
gtfs <- read_gtfs(local_gtfs_path)

## ------------------------------------------------------------------------
# gtfs <- read_gtfs("http://web.mta.info/developers/data/nyct/subway/google_transit.zip")

## ------------------------------------------------------------------------
gtfs <- set_servicepattern(gtfs)

## ------------------------------------------------------------------------
shp1 <- shapes_as_sf(gtfs$shapes)
shp1 <- st_transform(shp1, crs=2263)
shp1$length <- st_length(shp1)
shp2 <- shp1 %>% 
  as.data.frame() %>% 
  select(shape_id,length,-geometry) 

## ------------------------------------------------------------------------
service_pattern_summary <- gtfs$trips %>%
  left_join(gtfs$.$service_pattern, by="service_id") %>% 
  left_join(shp2, by="shape_id") %>%
  left_join(gtfs$stop_times, by="trip_id") %>% 
  group_by(servicepattern_id) %>% 
  summarise(trips = n(), 
            routes = n_distinct(route_id),
            total_distance_per_day_km = sum(as.numeric(length), 
                                    na.rm=TRUE)/1e3,
            route_avg_distance_km = (sum(as.numeric(length),
                                    na.rm=TRUE)/1e3)/(trips*routes),
            stops=(n_distinct(stop_id)/2))

## ------------------------------------------------------------------------
service_pattern_summary <- gtfs$.$date_servicepattern_table %>% 
  group_by(servicepattern_id) %>% 
  summarise(days_in_service = n()) %>% 
  left_join(service_pattern_summary, by="servicepattern_id")

## ------------------------------------------------------------------------
knitr::kable(service_pattern_summary)

## ------------------------------------------------------------------------
service_ids <- gtfs$.$service_pattern %>% 
  filter(servicepattern_id == 's_e25d6ca') %>% 
  pull(service_id)

head(service_ids) %>% 
  knitr::kable()

## ------------------------------------------------------------------------
gtfs$trips %>%
  filter(service_id %in% service_ids) %>%
  group_by(service_id, route_id) %>%
  summarise(count = n()) %>% 
  head() %>%
  knitr::kable()

## ------------------------------------------------------------------------
am_freq <- get_stop_frequency(gtfs, start_hour = 6, end_hour = 10, service_ids = service_ids)

## ------------------------------------------------------------------------
knitr::kable(head(am_freq))

## ------------------------------------------------------------------------
one_line_stops <- am_freq %>% 
    filter(route_id==1 & direction_id==0) %>%
    left_join(gtfs$stops, by ="stop_id")

## ------------------------------------------------------------------------
one_line_stops %>% 
  arrange(desc(headway)) %>% 
  select(stop_name, departures, headway) %>% 
  head() %>%
  knitr::kable()

## ------------------------------------------------------------------------
one_line_stops %>% 
  arrange(desc(headway)) %>% 
  select(stop_name, departures, headway) %>% 
  tail() %>%
  knitr::kable()

## ------------------------------------------------------------------------
nyc_stops_sf <- stops_as_sf(gtfs$stops)

## ------------------------------------------------------------------------
one_line_stops_sf <- nyc_stops_sf %>%
  right_join(one_line_stops, by="stop_id") 

## ------------------------------------------------------------------------
one_line_stops_sf %>% 
  ggplot() + 
  geom_sf(aes(color=headway)) +
  theme_bw()

## ------------------------------------------------------------------------
summary(one_line_stops$headway)

## ------------------------------------------------------------------------
am_route_freq <- get_route_frequency(gtfs, service_ids = service_ids, start_hour = 6, end_hour = 10) 
head(am_route_freq) %>%
  knitr::kable()

## ------------------------------------------------------------------------
# get_route_geometry needs a gtfs object that includes shapes as simple feature data frames
gtfs_sf <- gtfs_as_sf(gtfs)
routes_sf <- get_route_geometry(gtfs_sf, service_ids = service_ids)

## ------------------------------------------------------------------------
routes_sf <- routes_sf %>% 
  inner_join(am_route_freq, by = 'route_id')

## ---- fig.width=6, fig.height=10, warn=FALSE-----------------------------
# convert to an appropriate coordinate reference system
routes_sf_crs <- sf::st_transform(routes_sf, 26919) 
routes_sf_crs %>% 
  filter(median_headways<10) %>%
  ggplot() + 
  geom_sf(aes(colour=as.factor(median_headways))) + 
  labs(color = "Headways") +
  geom_sf_text(aes(label=route_id)) +
  theme_bw() 

## ------------------------------------------------------------------------
routes_sf_buffer <- st_buffer(routes_sf,
                              dist=routes_sf$total_departures/1e6)

## ---- fig.width=6, fig.height=10-----------------------------------------
routes_sf_buffer %>% 
  ggplot() + 
  geom_sf(colour=alpha("white",0),fill=alpha("red",0.2)) +
  theme_bw() 

## ------------------------------------------------------------------------
nyc_stop_am_departures_main <- nyc_stops_sf %>% left_join(am_freq, by = "stop_id") %>% 
  filter(departures>50)

## ------------------------------------------------------------------------
nyc_stops <- left_join(gtfs$stops,am_freq, by="stop_id")

stop_departures <- nyc_stops %>%  
  group_by(stop_name) %>%
  transmute(total_departures=sum(departures, na.rm=TRUE))

nyc_stops1 <- right_join(nyc_stops_sf,
                        stop_departures, by="stop_name")

stop_departures <- nyc_stops1 %>%
  filter(total_departures>100)

## ---- fig.width=6, fig.height=10-----------------------------------------
ggplot() + 
  geom_sf(data=routes_sf_buffer,colour=alpha("white",0),fill=alpha("red",0.3)) +
  geom_sf(data=stop_departures, aes(size=total_departures), shape=1) + 
  labs(size = "Departures (Hundreds)") +
  theme_bw() +
  theme(legend.position="none") +
  ggtitle("NYC MTA - Relative Departures by Route and Stop (AM)")

