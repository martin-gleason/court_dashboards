#leaflet

library(leaflet)
library(zipcode)

source("mock_etl.R")

client_zipcodes$`Client Zipcode` <- as.character(client_zipcodes$`Client Zipcode`)

chicago_demo <- client_zipcodes %>% left_join(zipcode, by = c("Client Zipcode" = "zip"))

m <- leaflet() %>%
  setView(lng = -87.7, lat = 41.9, zoom = 12)

m %>% addTiles() %>%
  addMarkers(lng = chicago_demo$longitude, lat = chicago_demo$latitude)
