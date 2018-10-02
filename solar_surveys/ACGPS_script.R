library(tidyverse)
library(survey)
library(gtools)
library(klaR)
setwd("/home/donniemeyer32085/git/capstone/solar_surveys/")


### ADOPTER DATA SET ### 
A <- read.csv("ADOPTER.csv")
A$HAVESOLAR <- recode(A$HAVESOLAR, `1` = 1, `2` = 50, `3` = 50, `4` = 50)
A$type <- as.integer(rep(1, nrow(A)))

### CONSIDERER DATA SET  ### 
C <- read.csv("CONSIDERER.csv")
C$HAVESOLAR <- recode(C$HAVESOLAR, `1` = 50, `2` = 0, `3` = 50, `4` = 50)
C$type <- as.integer(rep(2, nrow(C)))

### APPENED A and C DATA SETS ###
bind1 <- A[, names(A) %in% names(C)]
bind2 <- C[, names(C) %in% names(A)]
AC <- rbind(bind1, bind2)


### GPS DATA SET ###
GPS <- read.csv("GPS.csv")
GPS$type <- as.integer(rep(3, nrow(GPS)))
GPS$HAVESOLAR <- rep(0, nrow(GPS))

### APPENED AC and GPS DATA SETS ###
bind3 <- AC[, names(AC) %in% names(GPS)]
bind4 <- GPS[, names(GPS) %in% names(AC)]
ACGPS <- rbind(bind3, bind4)
rm(bind1, bind2, bind3, bind4)
#arrange 
ACGPS <- ACGPS %>% 
  arrange(CASE_ID)





### CREATE DEPENDENT VARIABLE, 1 = HAVE SOLAR AND 0 = DOES NOT HAVE SOLAR
ACGPS <- ACGPS %>% filter(!HAVESOLAR %in% 50)
#make HAVE solar a factor variable
ACGPS$HAVESOLAR <- factor(ACGPS$HAVESOLAR)
#bar graph of HAVESOLAR
ACGPS %>% 
  ggplot(aes(x = HAVESOLAR, fill = factor(type))) +
  geom_bar(color = "black") +
  scale_fill_manual(name="Type",
                    values=c("green4","darkgray", "cyan4"),
                    labels=c("solar","considered", "no_solar"))


# Save data set
write.csv(x = ACGPS, file = "ACGPS.csv")








### INDEPENDENT VARIABLES ###
variables <- list("INCOME_BINNED", "STATE", "EDUC_BINNED")
variables

#EDUC_BINNED
ACGPS_Vis <- ACGPS
ACGPS_Vis$EDUC_BINNED <- recode_factor(ACGPS_Vis$EDUC_BINNED, `1` = "hs_less", 
                                                           `2` = "some_college", 
                                                           `3` = "BA_BS", 
                                                           `4` = "MA_more")
                                                        
ACGPS_educ <- na.omit(ACGPS_Vis) %>%
  group_by(EDUC_BINNED) %>%
  summarize(Freq = n()) %>%
  mutate(Prop_EDUC = Freq/sum(Freq)) %>%
  arrange(desc(Prop_EDUC))
ggplot(data = na.omit(ACGPS_educ), mapping = aes(x = EDUC_BINNED, y = Prop_EDUC)) + 
  geom_col(color = "black") + 
  scale_x_discrete(limits = ACGPS_educ$EDUC_BINNED) +
  coord_flip()

#INCOME_BINNED
ACGPS_Vis$INCOME_BINNED <- recode_factor(ACGPS_Vis$INCOME_BINNED, `1` = "less_50", 
                                       `2` = "50_74999", 
                                       `3` = "75_99999", 
                                       `4` = "100_149999",
                                       `5` = "100_more",
                                       .ordered = TRUE)

ACGPS_income <- na.omit(ACGPS_Vis) %>%
  group_by(INCOME_BINNED) %>%
  summarize(Freq = n()) %>%
  mutate(Prop_INCOME = Freq/sum(Freq)) %>%
  arrange(desc(Prop_INCOME))
ggplot(data = na.omit(ACGPS_income), mapping = aes(x = INCOME_BINNED, y = Prop_INCOME)) + 
  geom_col(color = "black") + 
  scale_x_discrete(limits = ACGPS_income$INCOME_BINNED) +
  coord_flip()





### DESIGN ###
survey_design <- svydesign(data = ACGPS, id = ~1,  strata = ~STATE)


#### TABLE WITH SURVEY DESIGN ###
ACGPS_state <- svytable(~STATE, design = survey_design) %>%
  as.data.frame() %>%
  mutate(Prop_state = Freq/sum(Freq)) %>%
  arrange(desc(Prop_state))
ACGPS_state
#contingency tables
state_tab <- svytable(~STATE + HAVESOLAR, 
                    design = survey_design) 
state_tab
#convert to a data frame
state_tab <- as.data.frame(state_tab)
state_tab

ggplot(data = state_tab, mapping = aes(x = STATE, y = Freq, fill = HAVESOLAR)) + 
  geom_col(color = "black") +
  coord_flip()

ggplot(data = state_tab, mapping = aes(x = STATE, y = Freq, fill = HAVESOLAR)) + 
  geom_col(color = "black", position = "fill") +
  coord_flip()










### Clustering ###
cluster_data <- as.data.frame(ACGPS)
cluster_data$HAVESOLAR <- as.integer(cluster_data$HAVESOLAR)
glimpse(cluster_data)

set.seed(1985)
cluster_data <- na.omit((cluster_data)[,2:51])
cluster_data <- as.matrix(cluster_data)

cl <- kmodes(cluster_data, 3, iter.max = 10, weighted = FALSE)
cl

plot(jitter(cluster_data), col = cl$cluster)
points(cl$modes, col = 1:51, pch = 8)


### Logit regression ###
logit_data <- ACGPS %>% 
  dplyr::select(HAVESOLAR, INCOME_BINNED, STATE) %>% 
  filter(INCOME_BINNED < 95)
glimpse(logit_data)

lm1 <- glm(HAVESOLAR ~ factor(INCOME_BINNED) + factor(STATE), data = logit_data, family = "binomial")
summary(lm1)

summary(predict(lm1, type = "response"))
