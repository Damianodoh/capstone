library(tidyverse)
setwd("/home/donniemeyer32085/git/capstone/replica/")
replica <- read_csv("seeds_ii_replica.csv")
replica <- filter(replica, state_name == "California")
length(unique(replica$geoid))

#census, had to grab lat and lon from census websit
census_tract <- read_tsv("2017_Gaz_tracts_national.txt")
census_tract <- select(census_tract, c(2,7,8))
colnames(census_tract) <- tolower(names(census_tract))
census_tract <- rename(census_tract, lat = intptlat, lon = intptlong)

#join census tract data long and lat to df_0
replica <- left_join(replica, census_tract, by = "geoid")

#arrange rows
replica <- select(replica, c(geoid:centroid_x), lat, lon, everything())

#select variables of interest
replica <- select(replica, 
                  -centroid_x, 
                  -avg_ibi_pct,
                  -c(state_fips:state_abbr), 
                  -c(company_na:cust_cnt), 
                  -c(hh_gini_index:lihtc_qualified)
)

#create new data set
write_csv(replica, "df.csv")
