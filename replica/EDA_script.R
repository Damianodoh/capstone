library(tidyverse)
setwd("/home/donniemeyer32085/git/capstone/replica/")

### EDA ###

#import data
ca_df <- read_csv("tidy_df.csv")
glimpse(ca_df)

#classes
ca_df$county_name <- factor(ca_df$county_name)
ca_df$income <- factor(ca_df$income, levels = c("verylow", "low", "mid", "mod", "high"))

#take a randow sample
df_sample <- ca_df[sample(1:nrow(ca_df), 64300, replace=FALSE),]

#bars and histograms
df_sample %>% 
  ggplot(aes(x = bldg_cnt, fill = income)) +
  geom_histogram() +
  xlim(c(0, 1000)) +
  ylim(c(0, 2000))

df_sample %>% 
  ggplot(aes(x = income, y = bldg_cnt, fill = rent_own)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  facet_grid(.~housing_type)

df_sample %>% 
  ggplot(aes(x = income, y = bldg_cnt, fill = rent_own)) +
  geom_bar(stat = "identity", position = position_dodge()) 

# scatter_plots
df_sample %>% 
  ggplot(aes(x = income, y = bldg_cnt, color = rent_own)) +
  geom_jitter(alpha = 0.1) 

filter(df_sample, rent_own == "own") %>% 
  ggplot(aes(x = hh_med_income, y = bldg_cnt, color = rent_own)) +
  geom_point(alpha = 0.1) +
  geom_smooth() +
  scale_x_log10()

df_sample %>% 
  ggplot(aes(x = income, y = devp_cnt)) +
  geom_jitter(alpha = 0.1)

df_sample %>% 
  ggplot(aes(y = bldg_cnt, x = fam_med_income)) +
  geom_point(alpha = 0.1) +
  facet_wrap(.~ rent_own) 

df_sample %>% 
  ggplot(aes(y = bldg_cnt, x = fam_med_income, color = rent_own)) +
  geom_point(alpha = 0.1) +
  facet_wrap(.~ housing_type) 

#boxplots
df_sample ggplot(df_sample, aes(x=income, y=devp_m2, fill=income)) + 
  geom_boxplot() + 
  guides(fill=FALSE) + coord_flip() + 
  scale_y_log10()



