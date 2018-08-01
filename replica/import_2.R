setwd("/home/donniemeyer32085/git/capstone/replica/")
library(tidyverse)
one_eleven <- 1:11
data_frames <- paste0("df_", one_eleven, ".csv")
list_of_data <- lapply(data_frames, read_csv)

df_0 <- read_csv("df_0.csv")
df_1 <- read_csv("df_1.csv")
df_2 <- read_csv("df_2.csv")
df_3 <- read_csv("df_3.csv")
df_4 <- read_csv("df_4.csv")
df_5 <- read_csv("df_5.csv")
df_6 <- read_csv("df_6.csv")
df_7 <- read_csv("df_7.csv")
df_8 <- read_csv("df_8.csv")
df_9 <- read_csv("df_9.csv")
df_10 <- read_csv("df_10.csv")
df_11 <- read_csv("df_11.csv")

census_tract <- read_tsv("2017_Gaz_tracts_national.txt")
census_tract <- select(census_tract, c(2,7,8))
colnames(census_tract) <- tolower(names(census_tract))

#join census tract data long and lat to df_0
df_0 <- left_join(df_0, census_tract, by = "geoid")






