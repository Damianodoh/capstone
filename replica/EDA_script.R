library(tidyverse)
library(corrplot)
setwd("/home/donniemeyer32085/git/capstone/replica/")

### EDA ###

#import data
tidy_df <- read_csv("tidy_df.csv")
glimpse(tidy_df)

#create new variable for electricity consumption in kwhh
tidy_df <- tidy_df %>% 
  mutate(kwh_annual_usage = avg_monthly_consumption_kwh*12) %>% 
  mutate(kwh_in_mwh_annual = kwh_annual_usage/1000) %>% 
  mutate(diff_solargen_elec = mwh - kwh_in_mwh_annual) %>% 
  select(geoid:cust_cnt, diff_solargen_elec, kwh_in_mwh_annual, kwh_annual_usage, everything())
glimpse(tidy_df)

sum(tidy_df$diff_solargen_elec < 0)


#take a randow sample to work with smaller data set
df_sample <- tidy_df[sample(1:nrow(tidy_df), 64300, replace=FALSE),]





