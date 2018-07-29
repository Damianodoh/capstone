
### REPLICA DATA SET ##################################

#libraries
library(tidyverse)

#setwd
setwd("/home/donniemeyer32085/git/capstone/replica/")


### Import Data ######################################
replica <- read_csv("seeds_ii_replica.csv")
glimpse(replica)
dim(replica)


## Exrtacting df_0 (geographic)
df_0 <- select(replica, geoid:centroid_x)
write.csv(df_0, "df_0.csv")

## Extracting df_1 (lmi rooftop potential)
df_1 <- select(replica, very_low_mf_own_hh:high_sf_rent_mwh)
write.csv(df_1, "df_1.csv")

## Extracting df_2 (residential energy expenditure)
df_2 <- select(replica, very_low_mf_own_elep_hh:high_sf_rent_elep_hh)
write.csv(df_2, "df_2.csv")

## Extracting df_3 (electric utility)
df_3 <- select(replica, company_na:dlrs_kwh)
write.csv(df_3, "df_3.csv")

## Extracting df_4 (state residential solar incentives)
df_4 <- select(replica, avg_pbi_usd_p_kwh:avg_ibi_pct)
write.csv(df_4, "df_4.csv")

## Extracting df_5 (demographics)
df_5 <- select(replica, hh_size_1:hu_no_mortgage)
write.csv(df_5, "df_5.csv")

## Extracting df_6 (air quality index)
df_6 <- select(replica, aqi_max:aqi_median_description)
write.csv(df_6, "df_6.csv")

## Extracting df_7 (heating and cooling degree days)
df_7 <- select(replica, hdd:cdd_ci)
write.csv(df_7, "df_7.csv")

## Extracting df_8 (climate zones)
df_8 <- select(replica, climate_zone:moisture_regime)
write.csv(df_8, "df_8.csv")

## Extracting df_9 (locales)
df_9 <- select(replica, locale)
write.csv(df_9, "df_9.csv")

## Extracting df_10 (public housing)
df_10 <- select(replica, total_units:pct_eli_hh)
write.csv(df_10, "df_10.csv")

## Extracting df_11 (low income tax qaulified tracts)
df_11 <- select(replica, lihtc_qualified)
write.csv(df_11, "df_11.csv")



