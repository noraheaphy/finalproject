# save the environment to the working directory
save.image()
# clear environment
rm(list = ls())

setwd("/Users/nheaphy/Desktop/Files/Yale/research/portulaca/data")
# load the environment saved to the working directory
load(".Rdata") # appends (and overwrites) objects within the current workspace rather than 
# replacing it entirely, clear first please

library(tidyverse)
library(ggplot2)
library(ggpubr)
library(ggforce)
library(CoordinateCleaner)
library(countrycode)

# load in dataset
australia_null <- read.csv("australia_null_climate_extracted.csv", header = TRUE, sep = ",", 
                     na.strings = "") 

# remove everything with a NULL value
australia_null<- australia_null %>% filter(CHELSA_01 != "NULL" & CHELSA_12 != "NULL")

# put all columns in right format
australia_null$CHELSA_01 <- as.numeric(australia_null$CHELSA_01)
australia_null$CHELSA_12 <- as.numeric(australia_null$CHELSA_12)

# transform CHELSA_BIOL_01 to MAT, rename things, lat and lon got switched
australia_null <- australia_null %>% mutate(MAT = CHELSA_01*0.1) %>%
  rename("MAP" = "CHELSA_12", "lon" = "decimalLatitude", "lat" = "decimalLongitude") 
australia_null <- australia_null %>% select(-CHELSA_01)

# add a bogus species column to make the seas test work
australia_null <- australia_null %>% mutate(species = "species")

# make sure no points are in the ocean
flags <- clean_coordinates(x = australia_null, lon = "lon", 
                           lat = "lat", species = "species", tests = "seas")

australia_null <- australia_null[flags$.summary,]

# save null climate 
write.csv(australia_null, "australia_null_clean_11-29-2020.csv", row.names=F)

# make a biplot of MAT vs. MAP
ggplot(australia_null, aes(x = MAT, y = MAP)) +
  geom_point(size = 0.5) + 
  labs(title = "Australia Null Climate", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

# remove a handful of weird outliers
australia_null_no_outliers <- australia_null %>% filter(MAP < 3000 & MAT > 5.1)

# plot again
ggplot(australia_null_no_outliers, aes(x = MAT, y = MAP)) +
  geom_point(size = 0.5) + 
  labs(title = "Australia Null Climate", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

## bring in Portulaca and Calandrinia data to add onto biplot

calandrinia <- read.csv("cal_port_aus_10-24-2020.csv", header = TRUE, sep = ",",
                     na.strings = "") %>%
  filter(clade == "Calandrinia")

portulaca <- read.csv("cal_port_aus_10-24-2020.csv", header = TRUE, sep = ",",
                     na.strings = "") %>%
  filter(clade == "Portulaca")

# transform CHELSA_BIOL_01 to MAT
portulaca <- portulaca %>% mutate(MAT = CHELSA_BIOL_01*0.1) %>%
  rename("MAP" = "CHELSA_BIOL_12")
anacamps <- anacamps %>% mutate(MAT = CHELSA_BIOL_01*0.1) %>%
  rename("MAP" = "CHELSA_BIOL_12")
calandrinia <- calandrinia %>% mutate(MAT = CHELSA_BIOL_01*0.1) %>%
  rename("MAP" = "CHELSA_BIOL_12")

# plot null and Portulaca together
ggplot(australia_null_no_outliers, aes(x = MAT, y = MAP)) +
  geom_point(size = 1, color = "grey") + 
  geom_point(data = portulaca, color = "black", size = 0.3) +
  labs(title = "Australia Null Climate (with Portulaca)", 
       x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")
  
# plot null and Calandrinia together
ggplot(australia_null_no_outliers, aes(x = MAT, y = MAP)) +
  geom_point(size = 1, color = "grey") + 
  geom_point(data = calandrinia, color = "black", size = 0.3) +
  labs(title = "Australia Null Climate (with Calandrinia)", 
       x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")
