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

#gather hh size
df <- gather(df, hh_size, cnt_hh_size, hh_size_1:hh_size_4)

#hh_size count 
df$hh_size <- str_replace(df$hh_size, "hh_size_1", "1")
df$hh_size <- str_replace(df$hh_size, "hh_size_2", "2")
df$hh_size <- str_replace(df$hh_size, "hh_size_3", "3")
df$hh_size <- str_replace(df$hh_size, "hh_size_4", "4")

#spread variable column
df <- spread(df, variable, value)

#rename
df <- rename(df, income_group = income, 
             number_hh = hh, 
             suitable_buildings = bldg_cnt, 
             dev_roof_plns = devp_cnt,
             solar_capacity_mw = mw,
             solar_gen_MWh = mwh,
             avg_hh_elec_exp = elep_hh,
             heating_d_days = hdd,
             cooling_d_days = cdd
)

#rearange
df <- select(df, c(geoid:lon), c(income_group:solar_gen_MWh), everything())
df <- select(df, c(geoid:lon), income_group, housing_type, rent_own, number_hh, suitable_buildings, dev_roof_plns, devp_m2, solar_capacity_mw, solar_gen_MWh, everything())

#arrange rows and select vars of interest
df <- df %>% 
  select(c(geoid:centroid_x), lat, lon,  c(income_group:avg_hh_elec_exp), everything()) %>% 
  select(         -avg_ibi_pct,
                  -hu_own,
                  -hu_rent,
                  -c(company_na:cust_cnt), 
                  -hh_gini_index,
                  -c(pop_male:hu_monthly_owner_costs_greaterthan_1000dlrs),
                  -c(hu_med_val:aqi_median_description),
                  -c(total_units:pct_eli_hh),
                  
)





### Remove Uneeded Data ###
write_csv(df, "tidy_df.csv")
