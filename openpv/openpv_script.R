## LIBRARIES ##
library(tidyverse)
library(lubridate)

## DATA IMPORT ##
setwd("~/Desktop/Springboard/data_sets_capstone/openpv")
openpv <- read_csv("openpv_all.csv")
glimpse(openpv)
dim(openpv)

## DATA CLEANING ##

#change classes
openpv$date_installed <- mdy(openpv$date_installed)
openpv$cost <- as.integer(openpv$cost)

levels <- 
  
  openpv$install_type <- factor(openpv$install_type)

#seperating coloumns 
#openpv <- openpv %>% 
# separate(date_installed, c("year_installed", "month_installed", "day_installed"))


# matching names install_type variable 
openpv <- openpv %>%
  mutate(install_type = tolower(install_type))
openpv$install_type <- str_replace(openpv$install_type, "agriculture", " agricultural")
openpv$install_type <- str_replace(openpv$install_type, "commercial -  agricultural", "agricultural")
openpv$install_type <- str_replace(openpv$install_type, "commercial - builders", "commercial")
openpv$install_type <- str_replace(openpv$install_type, "commercial - other", "commercial")
openpv$install_type <- str_replace(openpv$install_type, "commercial - small business", "commercial")
openpv$install_type <- str_replace(openpv$install_type, "commerical", "commercial")
openpv$install_type <- str_replace(openpv$install_type, "education", "educational")
openpv$install_type <- str_replace(openpv$install_type, "educationalal", "educational")
openpv$install_type <- str_replace(openpv$install_type, "gov't/np", "government")
openpv$install_type <- str_replace(openpv$install_type, "residential/sf", "residential")
table(openpv$install_type)

#city variable
length(unique(openpv$city))

openpv <- openpv %>%
  mutate(city = tolower(city))

#county variable
length(unique(openpv$county))

openpv <- openpv %>%
  mutate(county = tolower(county))


#removing variables
is_na <- function(x){
  sum(is.na(x))
}
lapply(openpv, is_na)

openpv <- select(openpv, state:reported_annual_energy_prod)
dim(openpv)
glimpse(openpv)


#EDA
ggplot(data = openpv, aes(x= install_type)) +
  geom_bar()

ggplot(data = openpv, aes(x = size_kw, y = cost)) +
  geom_point(alpha = 0.2) +
  scale_x_log10()


