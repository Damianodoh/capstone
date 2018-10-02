library(tidyverse)
setwd("/home/donniemeyer32085/git/capstone/solar_surveys/")

### Working wit Catagorical Data in R ###

### ADOPTER DATA SET ### 
ACGPS <- read.csv("ACGPS.csv")
glimpse(ACGPS)
ACGPS <- ACGPS[,-1]
ACGPS$CASE_ID <- as.character(ACGPS$CASE_ID)
ACGPS$GPS_NAC_ADOPTER <- as.character(ACGPS$GPS_NAC_ADOPTER)
ACGPS$SURVEY_SOURCE <- as.character(ACGPS$SURVEY_SOURCE)

nlevels(ACGPS_factor$STATE)
levels(ACGPS_factor$STATE)
nlevels(ACGPS_factor$INCOME_BINNED)
levels(ACGPS_factor$INCOME_BINNED)

# Change all the character columns to factors
ACGPS_factors <- ACGPS %>% 
  mutate_if(is.integer, as.factor)
glimpse(responses_as_factors)

ACGPS_factors %>%
  summarise_if(is.factor, nlevels)

# Make a two column dataset with variable names and number of levels
number_of_levels <- ACGPS_factors %>% 
  summarise_all(nlevels) %>%
  gather(variable, num_levels)
number_of_levels
