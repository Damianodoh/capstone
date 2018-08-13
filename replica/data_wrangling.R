#setwd
setwd("/home/donniemeyer32085/git/capstone/replica/")
#libraries used
library(tidyverse)

#import data

df_0 <- read_csv("df_0.csv")
df_1 <- read_csv("df_1.csv")

### DATA WRANGLING ###
df_0_1 <- as.tibble(merge(df_0, df_1))

#california 
df_0_1_CA <- filter(df_0_1, state_name == "California")
glimpse(df_0_1_CA)
summary(df_0_1_CA)
rm(df_0, df_0_1, df_1)

#gather
df_0_1_CA <- gather(df_0_1_CA, economics_count, count, very_low_mf_own_hh : high_sf_rent_hh)
df_0_1_CA <- gather(df_0_1_CA, economics_suitable, suitable_buldings, very_low_mf_own_bldg_cnt : high_sf_rent_bldg_cnt)
df_0_1_CA <- gather(df_0_1_CA, economics_develope, developable_plane, very_low_mf_own_devp_cnt : high_sf_rent_devp_cnt)
glimpse(df_0_1_CA)

#rename variables df_0_1
df_0_1_CA <- rename(df_0_1_CA, lat = intptlat, lon = intptlong)
df_0_1_CA <- select(df_0_1_CA, -centroid_x)



df_0_1_CA <- select(df_0_1_CA, -c(state_fips:state_abbr))
dim(df_0_1_CA)
summary(df_0_1_CA)
class(df_0_1_CA$solar_potential)

#seperate tract economics column

### Remove Uneeded Data ###

write_csv(df_0_1_CA, "california.csv")
