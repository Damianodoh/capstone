library(tidyverse)
setwd("/home/donniemeyer32085/git/capstone/replica/")

#import data
df_all <- read_csv("seeds_ii_replica.csv")
df <- df_all %>% 
  filter(state_name == "California")


#census, had to grab lat and lon from census websit
census_tract <- read_tsv("2017_Gaz_tracts_national.txt")
census_tract <- select(census_tract, c(2,7,8))
colnames(census_tract) <- tolower(names(census_tract))
census_tract <- census_tract %>% rename(lat = intptlat, lon = intptlong)

#join census tract data long and lat to df_0
df <- left_join(df, census_tract, by = "geoid")


#gather dataset economic variables
df <- gather(df, economics, value, very_low_mf_own_hh : high_sf_rent_elep_hh)

#gsub county name
df$county_name <- gsub(" County", "", df$county_name)
df$economics <- gsub("very_low", "verylow", df$economics)

#seperate tract economics column
df <- as.tibble(separate(df, economics, into = c("income","housing_type","rent_own","a", "b"), sep = "_"))

#unite
df <- unite(df, variable, c("a", "b"))

#remove NA from variable
df$variable <- str_replace(df$variable, "hh_NA", "hh")
df$variable <- str_replace(df$variable, "mw_NA", "mw")
df$variable <- str_replace(df$variable, "mwh_NA", "mwh")

#spread variable column
df <- spread(df, variable, value)

#rearange
df <- df %>% 
  select(geoid:centroid_x, lat:mwh, everything())

### Remove Uneeded Data ###
write_csv(df, "tidy_df.csv")
