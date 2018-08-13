
library(tidyverse)
library(ggmap)
setwd("/home/donniemeyer32085/git/capstone/replica/")

CA <- read_csv("california.csv")



### Maping Script ##

#mapping geoid1
X1_1 <- as.vector(CA[, c("lon", "lat")])
class(X1_1)


map_X1_1 <- get_map(X1_1)
map.plot <- ggmap(map_X1_1)

map.plot + 
  geom_polygon(data = CA, aes(x=lon, y=lat, group = county_name), fill = NA, color = "red")

ggmap(map_X1_1) +
  geom_point(aes(lon, lat), data = CA)

toner_mapX1_1 <- get_map(X1_1, zoom = 5, source = "stamen", maptype = "watercolor")

ggmap(toner_mapX1_1) +
  geom_point(aes(lon, lat), data = CA)