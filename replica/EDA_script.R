library(tidyverse)
setwd("/home/donniemeyer32085/git/capstone/replica/")

### EDA ###

#import data
tidy_df <- read_csv("tidy_df_ca.csv")
glimpse(tidy_df)

#take a randow sample to work with smaller data set
df_sample <- tidy_df[sample(1:nrow(ca_df), 64300, replace=FALSE),]

###########################################################################bars and histograms
df_sample %>% 
  ggplot(aes(x = suitable_buildings, fill = income_group)) +
  geom_histogram() +
  xlim(c(0, 1000)) +
  ylim(c(0, 2000))

df_sample %>% 
  ggplot(aes(x = income_group, y = suitable_buildings, fill = rent_own)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  facet_grid(.~housing_type)


################################################################################ scatter_plots

filter(df_sample, rent_own == "own") %>% 
  ggplot(aes(x = hh_med_income, y = suitable_buildings, color = rent_own)) +
  geom_point(alpha = 0.1) 

filter(df_sample, rent_own == "rent" & income_group == "verylow" & housing_type == "sf") %>% 
  ggplot(aes(x = solar_gen_MWh , y = suitable_buildings, color = climate_zone_description)) +
  geom_point(alpha = 0.1) +
  facet_wrap(~locale)

df_sample %>% 
  ggplot(aes(x = income_group, y = dev_roof_plns, color = "factor(climate_zone)")) +
  geom_jitter(alpha = 0.1)

df_sample %>% 
  ggplot(aes(y = suitable_buildings, x = fam_med_income)) +
  geom_point(alpha = 0.1) +
  facet_wrap(.~ rent_own) 

vl_sf_r <- filter(df_sample, income_group == "verylow")
vl_sf_r %>% 
  ggplot(aes(x = number_hh, y = suitable_buildings)) +
  geom_jitter(alpha = 0.1) +
  geom_smooth(method = "lm") +
  facet_wrap(rent_own ~ housing_type) +
  scale_x_log10() +
  scale_y_log10()

########################################################################################boxplots




