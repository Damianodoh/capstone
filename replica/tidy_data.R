#setwd
setwd("/home/donniemeyer32085/git/capstone/replica/")
#libraries used
library(tidyverse)

#import individual data se
df <- read_csv("df.csv")
summary(df)


#gather dataset
df <- gather(df, economics, value, very_low_mf_own_hh : high_sf_rent_elep_hh)
glimpse(df)
summary(df)

#replace very_low with verylow
table(df$economics)
df$economics <- str_replace(df$economics, "very_low_mf_own_bldg_cnt", "verylow_mf_own_bldg_cnt")
df$economics <- str_replace(df$economics, "very_low_mf_own_devp_cnt", "verylow_mf_own_devp_cnt")
df$economics <- str_replace(df$economics, "very_low_mf_own_devp_m2", "verylow_mf_own_devp_m2")
df$economics <- str_replace(df$economics, "very_low_mf_own_elep_hh", "verylow_mf_own_elep_hh")

df$economics <- str_replace(df$economics, "very_low_mf_own_hh", "verylow_mf_own_hh")
df$economics <- str_replace(df$economics, "very_low_mf_own_mw", "verylow_mf_own_mw")
df$economics <- str_replace(df$economics, "very_low_mf_own_mwh", "verylow_mf_own_mwh")
df$economics <- str_replace(df$economics, "very_low_mf_rent_bldg_cnt", "verylow_mf_rent_bldg_cnt")

df$economics <- str_replace(df$economics, "very_low_mf_rent_bldg_cnt", "verylow_mf_rent_bldg_cnt")
df$economics <- str_replace(df$economics, "very_low_mf_rent_devp_cnt", "verylow_mf_rent_devp_cnt")
df$economics <- str_replace(df$economics, "very_low_mf_rent_devp_m2", "verylow_mf_rent_devp_m2")
df$economics <- str_replace(df$economics, "very_low_mf_rent_elep_hh", "verylow_mf_rent_elep_hh")

df$economics <- str_replace(df$economics, "very_low_mf_rent_hh", "verylow_mf_rent_hh")
df$economics <- str_replace(df$economics, "very_low_mf_rent_mw", "verylow_mf_rent_mw")
df$economics <- str_replace(df$economics, "very_low_mf_rent_mwh", "verylow_mf_rent_mwh")
df$economics <- str_replace(df$economics, "very_low_sf_own_bldg_cnt", "verylow_sf_own_bldg_cnt")

df$economics <- str_replace(df$economics, "very_low_sf_own_devp_cnt", "verylow_sf_own_devp_cnt")
df$economics <- str_replace(df$economics, "very_low_sf_own_devp_m2", "verylow_sf_own_devp_m2")
df$economics <- str_replace(df$economics, "very_low_sf_own_elep_hh ", "verylow_sf_own_elep_hh ")
df$economics <- str_replace(df$economics, "very_low_sf_own_hh", "verylow_sf_own_hh")

df$economics <- str_replace(df$economics, "very_low_sf_own_elep_hh", "verylow_sf_own_elep_hh")
df$economics <- str_replace(df$economics, "very_low_sf_own_mw", "verylow_sf_own_mw")
df$economics <- str_replace(df$economics, "very_low_sf_own_mwh ", "verylow_sf_own_mwh ")
df$economics <- str_replace(df$economics, "very_low_sf_rent_bldg_cnt", "verylow_sf_rent_bldg_cnt")

df$economics <- str_replace(df$economics, "very_low_sf_rent_devp_cnt", "verylow_sf_rent_devp_cnt")
df$economics <- str_replace(df$economics, "very_low_sf_rent_devp_m2", "verylow_sf_rent_devp_m2")
df$economics <- str_replace(df$economics, "very_low_sf_rent_elep_hh", "verylow_sf_rent_elep_hh")
df$economics <- str_replace(df$economics, "very_low_sf_rent_hh", "verylow_sf_rent_hh")

df$economics <- str_replace(df$economics, "very_low_sf_rent_mw", "verylow_sf_rent_mw")
df$economics <- str_replace(df$economics, "very_low_sf_rent_mwh", "verylow_sf_rent_mwh")

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
summary(df)

#spread variable column
df <- spread(df, variable, value)
summary(df)

#rearange
glimpse(df)
df <- select(df, c(geoid:lon), c(income:mwh), everything())

### Remove Uneeded Data ###
write_csv(df, "tidy_df.csv")
