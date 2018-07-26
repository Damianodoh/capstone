## LIBRARIES ##
library(tidyverse)
library(lubridate)

## DATA IMPORT ##
setwd("/home/donniemeyer32085/git/capstone/openpv")
openpv <- read_csv("openpv_all.csv")
glimpse(openpv)
dim(openpv)

## FILTERING CALIFORNIA

## filtering for california, by far the most numerous amount of solar panel installations
openpv <- filter(openpv, state == "CA" & install_type == "residential")
glimpse(openpv)
dim(openpv)



## DATA CLEANING ##


#change classes
#openpv$date_installed <- mdy(openpv$date_installed)
openpv$cost <- as.numeric(openpv$cost)

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

# matching names install_type variable
openpv$utility_clean <- str_replace(openpv$utility_clean, "Pacific Gas & Electric Company", "Pacific Gas & Electric")
openpv$utility_clean <- str_replace(openpv$utility_clean, "Pacific Power & Light Company", "Pacific Gas & Electric")
openpv$utility_clean <- str_replace(openpv$utility_clean, "Pacific Gas & Electric Co", "Pacific Gas & Electric")
openpv$utility_clean <- str_replace(openpv$utility_clean, "Southern California Edison Co", "Southern California Edison")


##Make variables lowercase and identical

#city variable
length(unique(openpv$city))
openpv <- openpv %>%
  mutate(city = tolower(city))
#county variable
length(unique(openpv$county))
openpv <- openpv %>%
  mutate(county = tolower(county))

#separate year out of date
openpv <- separate(openpv, date_installed, into = c("day", "month", "year"), sep = "/")

#counting na function
is_na <- function(x){
  sum(is.na(x))
}
open_pv_na_list <- sapply(openpv, is_na)
na_alot <- open_pv_na_list/nrow(openpv)

variable_keep <- na_alot[na_alot <= .9]
variable_keep
class(names(variable_keep))

variable_keep <- names(variable_keep)
class(variable_keep)



#selecting variables of interest, remving variables with highh percentage of NA's
openpv <- select(openpv, variable_keep)
dim(openpv)
glimpse(openpv)



#clean data#
openpv_clean <- select(openpv, year, state, county, city, zipcode, everything())
openpv_clean <- select(openpv, -c("day", "month", "state", "install_type","manuf2_clean", "manuf3_clean", "3rdparty"))
glimpse(openpv_clean)

#### SAVE CLEAN DATA SET ###
write.csv(openpv_clean, "openpv_clean.csv")

### A complete Cases data set ###
openpv_complete_cases <- openpv_clean[complete.cases(openpv_clean),]
glimpse(openpv_complete_cases)

write.csv(openpv_complete_cases, "openpv_complete_cases.csv")


