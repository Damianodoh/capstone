library(tidyverse)
library(ggmap)
library(maptools)
library(sp)
library(rgdal)
setwd("/home/donniemeyer32085/git/capstone/replica/")
ca_df <- read_csv("tidy_df_ca.csv")


#class as factors 
ca_df$state_fips <- factor(ca_df$state_fips)
ca_df$county_fips <- factor(ca_df$county_fips)


### Maping Script ##
sb_df <- filter(ca_df, county_name == "San Bernardino")
bb_loc <- c(lon = -116.9114, lat = 34.2439)
sb_df <- arrange(sb_df, state_fips, county_fips, tract_fips)


#get map of san bernardino
bb_map <- get_map(location = bb_loc, zoom = 11, scale = 1)

# Plot map at zoom level 5
ggmap(bb_map)

#equivilant
ggplot() + 
  geom_point(aes(lon, lat), data = sb_df)

#plat lat lon points on sb map
ggmap(bb_map) +
  geom_point(aes(lon, lat, color = avg_monthly_consumption_kwh), data = sb_df)

#plat lat lon points on sb map
ggmap(bb_map) +
  geom_point(aes(lon, lat, color = suitable_buildings), data = filter(sb_df, income_group == "verylow"))
ggmap(bb_map) +
  geom_point(aes(lon, lat, color = devp_m2 ), data = filter(sb_df, income_group == "verylow"))
ggmap(bb_map) +
  geom_point(aes(lon, lat, color = devp_m2 ), data = filter(sb_df, income_group == "high"))
ggmap(bb_map) +
  geom_point(aes(lon, lat, color = avg_monthly_bill_dlrs), data = filter(sb_df, income_group == "verylow"))

# Add source and maptype to get toner map from Stamen Maps
bb_map_bw <- get_map(bb_loc, zoom = 10, source = "stamen", maptype = "toner")
# Edit to display toner map
ggmap(bb_map_bw) +
  geom_point(aes(lon, lat, color = solar_capacity_mw), data = filter(sb_df, income_group == "verylow"))

# Add a maptype argument to get a satellite map
bb_map_sat <- get_map(bb_loc, zoom = 10, maptype = "satellite")
# Edit to display satellite map
ggmap(bb_map_sat) +
  geom_point(aes(lon, lat, color = solar_capacity_mw), data = filter(sb_df, income_group == "verylow"))

# Use base_layer argument to ggmap() to specify data and x, y mappings
ggmap(bb_map_bw) +
  geom_point(aes(lon, lat, color = solar_capacity_mw), data = filter(sb_df, income_group == "verylow"))

ggmap(bb_map_bw, base_layer = ggplot(filter(sb_df, income_group == "verylow"), aes(lon, lat))) +
  geom_point(aes(color = solar_capacity_mw))

# Use base_layer argument to ggmap() and add facet_wrap()
ggmap(bb_map_bw, base_layer = ggplot(sb_df, aes(lon, lat))) +
  geom_point(aes(color = locale)) 




