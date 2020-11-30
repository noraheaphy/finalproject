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

# load in datasets
anacamps <- read.csv("anacamps_clean_10-10-2020.csv", header = TRUE, sep = ",", 
                     na.strings = "") 
cactaceae <- read.csv("cactaceae_clean_10-08-2020.csv", header = TRUE, sep = ",", 
                      na.strings = "") 
calandrinia <- read.csv("calandrinia_clean_10-08-2020.csv", header = TRUE, sep = ",", 
                        na.strings = "") 
portulaca <- read.csv("portulaca_clean_10-08-2020.csv", header = TRUE, sep = ",", 
                      na.strings = "") 
talinum <- read.csv("talinum_clean_10-09-2020.csv", header = TRUE, sep = ",", 
                    na.strings = "") 

# trim all datasets to same length
anacamps <- anacamps[1:16]
cactaceae <- cactaceae[1:16]
calandrinia <- calandrinia[1:16]
portulaca <- portulaca[1:16]
talinum <- talinum[1:16]

# make a new column to designate the clade
anacamps$clade <- "Anacampserotaceae"
cactaceae$clade <- "Cactaceae"
calandrinia$clade <- "Calandrinia"
portulaca$clade <- "Portulaca"
talinum$clade <- "Talinum"

# bind all datasets together and export to extract environmental variables in ArcGIS
calandrinia$gbifID <- as.character(calandrinia$gbifID)
all_localities <- bind_rows(anacamps, cactaceae, calandrinia, portulaca, talinum)
write.csv(all_localities, "all_localities_10-11-2020.csv", 
          row.names=F)

# bring dataset with extracted environmental variables back into R
chelsa_localities <- read.csv("all_localities_extracted_chelsa.csv", header = TRUE, sep = ",", 
                                            na.strings = "") 

# remove rows with NULL values
chelsa_localities_null <- filter(chelsa_localities, CHELSA_BIOL_01 == "NULL" | 
                              CHELSA_BIOL_02 == "NULL" | 
                              CHELSA_BIOL_03 == "NULL" | 
                              CHELSA_BIOL_04 == "NULL" | 
                              CHELSA_BIOL_05 == "NULL" | 
                              CHELSA_BIOL_06 == "NULL" | 
                              CHELSA_BIOL_07 == "NULL" | 
                              CHELSA_BIOL_08 == "NULL" | 
                              CHELSA_BIOL_09 == "NULL" | 
                              CHELSA_BIOL_10 == "NULL" | 
                              CHELSA_BIOL_11 == "NULL" | 
                              CHELSA_BIOL_12 == "NULL" | 
                              CHELSA_BIOL_13 == "NULL" | 
                              CHELSA_BIOL_14 == "NULL" | 
                              CHELSA_BIOL_15 == "NULL" | 
                              CHELSA_BIOL_16 == "NULL" |
                              CHELSA_BIOL_17 == "NULL" | 
                              CHELSA_BIOL_18 == "NULL" | 
                              CHELSA_BIOL_19 == "NULL")

chelsa_localities <- setdiff(chelsa_localities, chelsa_localities_null)
rm(chelsa_localities_null)

# convert all the columns to the right format
chelsa_localities$clade <- as.factor(chelsa_localities$clade)
chelsa_localities$CHELSA_BIOL_01 <- as.numeric(chelsa_localities$CHELSA_BIOL_01)
chelsa_localities$CHELSA_BIOL_02 <- as.numeric(chelsa_localities$CHELSA_BIOL_02)
chelsa_localities$CHELSA_BIOL_03 <- as.numeric(chelsa_localities$CHELSA_BIOL_03)
chelsa_localities$CHELSA_BIOL_04 <- as.numeric(chelsa_localities$CHELSA_BIOL_04)
chelsa_localities$CHELSA_BIOL_05 <- as.numeric(chelsa_localities$CHELSA_BIOL_05)
chelsa_localities$CHELSA_BIOL_06 <- as.numeric(chelsa_localities$CHELSA_BIOL_06)
chelsa_localities$CHELSA_BIOL_07 <- as.numeric(chelsa_localities$CHELSA_BIOL_07)
chelsa_localities$CHELSA_BIOL_08 <- as.numeric(chelsa_localities$CHELSA_BIOL_08)
chelsa_localities$CHELSA_BIOL_09 <- as.numeric(chelsa_localities$CHELSA_BIOL_09)
chelsa_localities$CHELSA_BIOL_10 <- as.numeric(chelsa_localities$CHELSA_BIOL_10)
chelsa_localities$CHELSA_BIOL_11 <- as.numeric(chelsa_localities$CHELSA_BIOL_11)
chelsa_localities$CHELSA_BIOL_12 <- as.numeric(chelsa_localities$CHELSA_BIOL_12)
chelsa_localities$CHELSA_BIOL_13 <- as.numeric(chelsa_localities$CHELSA_BIOL_13)
chelsa_localities$CHELSA_BIOL_14 <- as.numeric(chelsa_localities$CHELSA_BIOL_14)
chelsa_localities$CHELSA_BIOL_15 <- as.numeric(chelsa_localities$CHELSA_BIOL_15)
chelsa_localities$CHELSA_BIOL_16 <- as.numeric(chelsa_localities$CHELSA_BIOL_16)
chelsa_localities$CHELSA_BIOL_17 <- as.numeric(chelsa_localities$CHELSA_BIOL_17)
chelsa_localities$CHELSA_BIOL_18 <- as.numeric(chelsa_localities$CHELSA_BIOL_18)
chelsa_localities$CHELSA_BIOL_19 <- as.numeric(chelsa_localities$CHELSA_BIOL_19)

############ PORTULACA-ANACAMPSEROTACEAE ############

# subset to clade and environmental variables for Anacampserotaceae and Portulaca
portulaca_anacamps <- chelsa_localities %>% filter(clade == "Anacampserotaceae" |
                                                           clade == "Portulaca") %>%
  select(clade, CHELSA_BIOL_01:CHELSA_BIOL_19)

########### MANOVA ###########

responses <- paste(colnames(portulaca_anacamps)[2:20], collapse = ",")
myformula <- as.formula(paste0("cbind(", responses ,") ~ clade" ))
speciesMAN <- manova(myformula, data = portulaca_anacamps) 
summary(speciesMAN, test="Wilks") 
summary.aov(speciesMAN) 

########### BOX PLOTS ###########

# box plots with p values
my_comparisons <- list(c("Portulaca", "Anacampserotaceae"))

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_01, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Annual Temperature", x = "clade", 
       y = "Mean Annual Temperature [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_02, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Mean Diurnal Range", x = "clade", 
       y = "Mean Diurnal Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_03, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Isothermality", x = "clade", 
       y = "Isothermality") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_04, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Temperature Seasonality", x = "clade", 
       y = "Temperature Seasonality [standard deviation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_05, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Max Temperature of Warmest Month", x = "clade", 
       y = "Max Temperature of Warmest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_06, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Min Temperature of Coldest Month", x = "clade", 
       y = "Min Temperature of Coldest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_07, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Temperature Annual Range", x = "clade", 
       y = "Temperature Annual Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_08, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Mean Temperature of Wettest Quarter", x = "clade", 
       y = "Mean Temperature of Wettest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_09, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Mean Temperature of Driest Quarter", x = "clade", 
       y = "Mean Temperature of Driest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_10, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Mean Temperature of Warmest Quarter", x = "clade", 
       y = "Mean Temperature of Warmest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_11, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Mean Temperature of Coldest Quarter", x = "clade", 
       y = "Mean Temperature of Coldest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_12, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Annual Precipitation", x = "clade", 
       y = "Mean Annual Precipitation [mm/year]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_13, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Wettest Month", x = "clade", 
       y = "Precipitation of Wettest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_14, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Driest Month", x = "clade", 
       y = "Precipitation of Driest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_15, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation Seasonality", x = "clade", 
       y = "Precipitation Seasonality [coefficient of variation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_16, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Wettest Quarter", x = "clade", 
       y = "Precipitation of Wettest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_17, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Driest Quarter", x = "clade", 
       y = "Precipitation of Driest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_18, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Warmest Quarter", x = "clade", 
       y = "Precipitation of Warmest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_19, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4", "#7CAE00")) +
  labs(title = "Precipitation of Coldest Quarter", x = "clade", 
       y = "Precipitation of Coldest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

########### KERNEL DENSITY PLOTS ###########

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_01, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Temperature") +
  xlab("Mean Annual Temperature [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_02, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Diurnal Range") +
  xlab("Mean Diurnal Range [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_03, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Isothermality") +
  xlab("Isothermality")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_04, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Seasonality") +
  xlab("Temperature Seasonality [standard deviation]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_05, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Max Temperature of Warmest Month") +
  xlab("Max Temperature of Warmest Month [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_06, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Min Temperature of Coldest Month") +
  xlab("Min Temperature of Coldest Month [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_07, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Annual Range") +
  xlab("Temperature Annual Range [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_08, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Wettest Quarter") +
  xlab("Mean Temperature of Wettest Quarter [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_09, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Driest Quarter") +
  xlab("Mean Temperature of Driest Quarter [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_10, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Warmest Quarter") +
  xlab("Mean Temperature of Warmest Quarter [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_11, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Coldest Quarter") +
  xlab("Mean Temperature of Coldest Quarter [°C*10]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_12, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Precipitation") +
  xlab("Mean Annual Precipitation [mm/year]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_13, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Month") +
  xlab("Precipitation of Wettest Month [mm/month]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_14, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Month") +
  xlab("Precipitation of Driest Month [mm/month]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_15, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation Seasonality") +
  xlab("Precipitation Seasonality [coefficient of variation]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_16, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Quarter") +
  xlab("Precipitation of Wettest Quarter [mm/quarter]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_17, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Quarter") +
  xlab("Precipitation of Driest Quarter [mm/quarter]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_18, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Warmest Quarter") +
  xlab("Precipitation of Warmest Quarter [mm/quarter]")

ggplot(portulaca_anacamps, aes(x = CHELSA_BIOL_19, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Coldest Quarter") +
  xlab("Precipitation of Coldest Quarter [mm/quarter]")

########### BIPLOTS ###########

portulaca_anacamps_scaled <- portulaca_anacamps %>% mutate(MAT = CHELSA_BIOL_01*0.1)
portulaca_anacamps_scaled$clade <- droplevels(portulaca_anacamps_scaled$clade)

portulaca <- portulaca_anacamps_scaled %>% filter(clade == "Portulaca")
anacamps <- portulaca_anacamps_scaled %>% filter(clade == "Anacampserotaceae")

ggplot(anacamps, aes(x = MAT, y = CHELSA_BIOL_12)) +
  geom_point(size = 0.6, color = "grey") +
  geom_point(data = portulaca, color = "black", size = 0.4) +
  labs(title = "Anacampserotaceae and Portulaca Global Climate Space", 
       x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

ggplot(portulaca_anacamps_scaled, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 1) + 
  scale_color_manual(values = c("Anacampserotaceae" = "grey", "Portulaca" = "black")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (kg/m^2)")

## Biplot for Portulaca-Anacampserotaceae with outgroups Cactaceae and Talinum

outgroups_portulaca_anacamps <- chelsa_localities %>% filter(clade != "Calandrinia") %>%
  select(clade, species, CHELSA_BIOL_01:CHELSA_BIOL_19) %>% 
  filter(species != "Talinum paniculatum" & species != "Talinum fruticosum")

outgroups_portulaca_anacamps <- outgroups_portulaca_anacamps %>% 
  mutate(MAT = CHELSA_BIOL_01*0.1)
outgroups_portulaca_anacamps$clade <- droplevels(outgroups_portulaca_anacamps$clade)

ggplot(outgroups_portulaca_anacamps, aes(x = MAT, y = ..scaled.., color = clade)) +
  geom_density(alpha = 0.5) + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Annual Temperature", x = "Mean Annual Temperature (°C)")

ggplot(outgroups_portulaca_anacamps, aes(x = CHELSA_BIOL_12, y = ..scaled.., color = clade)) +
  geom_density(alpha = 0.5) + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Annual Precipitation", x = "Mean Annual Precipitation (kg/m^2)")

ggplot(outgroups_portulaca_anacamps, aes(x = CHELSA_BIOL_15, y = ..scaled.., color = clade)) +
  geom_density(alpha = 0.5) + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Precipitation Seasonality", x = "Precipitation Seasonality")

ggplot(outgroups_portulaca_anacamps, aes(x = CHELSA_BIOL_06, y = ..scaled.., color = clade)) +
  geom_density(alpha = 0.5) + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Minimum Temperature of Coldest Month", 
       x = "Min Temp Coldest Month (°C*10)")

ggplot(outgroups_portulaca_anacamps, aes(x = CHELSA_BIOL_11, y = ..scaled.., color = clade)) +
  geom_density(alpha = 0.5) + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Temperature of Coldest Quarter", 
       x = "Mean Temp Coldest Quarter (°C)")

ggplot(outgroups_portulaca_anacamps, aes(x = clade, y = MAT, color = clade)) +
  geom_boxplot() + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                               "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Annual Temperature", x = "clade", 
       y = "Mean Annual Temperature (°C)")

ggplot(outgroups_portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_12, color = clade)) +
  geom_boxplot() + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Annual Precipitation", x = "clade", 
       y = "Mean Annual Precipitation (kg/m^2)")

ggplot(outgroups_portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_15, color = clade)) +
  geom_boxplot() + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Precipitation Seasonality", x = "clade", 
       y = "Precipitation Seasonality")

ggplot(outgroups_portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_06, color = clade)) +
  geom_boxplot() + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Minimum Temperature of the Coldest Month", x = "clade", 
       y = "Min Temp Coldest Month (°C)")

ggplot(outgroups_portulaca_anacamps, aes(x = clade, y = CHELSA_BIOL_11, color = clade)) +
  geom_boxplot() + 
  scale_color_manual(values = c("Cactaceae" = "darkgrey", "Talinum" = "green",
                                "Portulaca" = "blue", "Anacampserotaceae" = "red")) +
  labs(title = "Mean Temperature of the Coldest Quarter", x = "clade", 
       y = "Mean Temp Coldest Quarter (°C)")


###### MANOVA for Portulaca v. Anacamps/Cactaceae/Talinum

responses <- paste(colnames(outgroups_portulaca_anacamps)[3:21], collapse = ",")
myformula <- as.formula(paste0("cbind(", responses ,") ~ clade" ))
speciesMAN <- manova(myformula, data = outgroups_portulaca_anacamps) 
summary(speciesMAN, test="Wilks") 
summary.aov(speciesMAN) 

portulaca_temp <- outgroups_portulaca_anacamps %>% filter(clade == "Portulaca") %>%
  mutate(portulaca = "yes")

not_portulaca_temp <- outgroups_portulaca_anacamps %>% filter(clade != "Portulaca") %>%
  mutate(portulaca = "no")

outgroups_portulaca_anacamps <- bind_rows(portulaca_temp, not_portulaca_temp)
rm(portulaca_temp, not_portulaca_temp)

responses <- paste(colnames(outgroups_portulaca_anacamps)[3:21], collapse = ",")
myformula <- as.formula(paste0("cbind(", responses ,") ~ portulaca" ))
speciesMAN <- manova(myformula, data = outgroups_portulaca_anacamps) 
summary(speciesMAN, test="Wilks") 
summary.aov(speciesMAN) 

############## Calandrinia-Portulaca ##############

calandrinia_portulaca <- chelsa_localities %>% filter(clade == "Portulaca" | 
                                                        clade == "Calandrinia")
write.csv(calandrinia_portulaca, "calandrinia_portulaca_10-24-2020.csv", row.names = F)

cal_port_aus <- read.csv("cal_port_aus_10-24-2020.csv", header = TRUE, sep = ",", 
                         na.strings = "")

# remove rows with NULL values
cal_port_aus_null <- filter(cal_port_aus, CHELSA_BIOL_01 == "NULL" | 
                                   CHELSA_BIOL_02 == "NULL" | 
                                   CHELSA_BIOL_03 == "NULL" | 
                                   CHELSA_BIOL_04 == "NULL" | 
                                   CHELSA_BIOL_05 == "NULL" | 
                                   CHELSA_BIOL_06 == "NULL" | 
                                   CHELSA_BIOL_07 == "NULL" | 
                                   CHELSA_BIOL_08 == "NULL" | 
                                   CHELSA_BIOL_09 == "NULL" | 
                                   CHELSA_BIOL_10 == "NULL" | 
                                   CHELSA_BIOL_11 == "NULL" | 
                                   CHELSA_BIOL_12 == "NULL" | 
                                   CHELSA_BIOL_13 == "NULL" | 
                                   CHELSA_BIOL_14 == "NULL" | 
                                   CHELSA_BIOL_15 == "NULL" | 
                                   CHELSA_BIOL_16 == "NULL" |
                                   CHELSA_BIOL_17 == "NULL" | 
                                   CHELSA_BIOL_18 == "NULL" | 
                                   CHELSA_BIOL_19 == "NULL")

rm(cal_port_aus_null)

# convert all the columns to the right format
cal_port_aus$clade <- as.factor(cal_port_aus$clade)

cal_port_aus <- cal_port_aus %>% select(clade, CHELSA_BIOL_01:CHELSA_BIOL_19)

########### MANOVA ###########

responses <- paste(colnames(cal_port_aus)[2:20], collapse = ",")
myformula <- as.formula(paste0("cbind(", responses ,") ~ clade" ))
speciesMAN <- manova(myformula, data = cal_port_aus) 
summary(speciesMAN, test="Wilks") 
summary.aov(speciesMAN) 

########### BIPLOTS ###########

cal_port_aus_scaled <- cal_port_aus %>% mutate(MAT = CHELSA_BIOL_01*0.1)

ggplot(cal_port_aus_scaled, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 0.5) + 
  scale_color_manual(values = c("Calandrinia" = "red", "Portulaca" = "lightblue")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (kg/m^2)")

ggplot(cal_port_aus_scaled, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 0.5) + 
  scale_color_manual(values = c("Calandrinia" = "lightblue", "Portulaca" = "red")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (kg/m^2)")

ggplot(calandrinia_aus, aes(x = MAT, y = CHELSA_BIOL_12)) +
  geom_point(size = 0.6, color = "grey") +
  geom_point(data = portulaca_aus, color = "black", size = 0.6) +
  labs(title = "Calandrinia and Portulaca Australian Climate Space", 
       x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

ggplot(cal_port_aus_scaled, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 1) + 
  scale_color_manual(values = c("Calandrinia" = "grey", "Portulaca" = "black")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (kg/m^2)")

########### BOX PLOTS ###########

# box plots with p values
my_comparisons <- list(c("Portulaca", "Calandrinia"))

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_01, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Annual Temperature", x = "clade", 
       y = "Mean Annual Temperature [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_02, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Diurnal Range", x = "clade", 
       y = "Mean Diurnal Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_03, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Isothermality", x = "clade", 
       y = "Isothermality") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_04, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Temperature Seasonality", x = "clade", 
       y = "Temperature Seasonality [standard deviation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_05, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Max Temperature of Warmest Month", x = "clade", 
       y = "Max Temperature of Warmest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_06, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Min Temperature of Coldest Month", x = "clade", 
       y = "Min Temperature of Coldest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_07, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Temperature Annual Range", x = "clade", 
       y = "Temperature Annual Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_08, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Temperature of Wettest Quarter", x = "clade", 
       y = "Mean Temperature of Wettest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_09, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Temperature of Driest Quarter", x = "clade", 
       y = "Mean Temperature of Driest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_10, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Temperature of Warmest Quarter", x = "clade", 
       y = "Mean Temperature of Warmest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_11, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Temperature of Coldest Quarter", x = "clade", 
       y = "Mean Temperature of Coldest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_12, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Mean Annual Precipitation", x = "clade", 
       y = "Mean Annual Precipitation [mm/year]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_13, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Wettest Month", x = "clade", 
       y = "Precipitation of Wettest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_14, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Driest Month", x = "clade", 
       y = "Precipitation of Driest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_15, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation Seasonality", x = "clade", 
       y = "Precipitation Seasonality [coefficient of variation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_16, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Wettest Quarter", x = "clade", 
       y = "Precipitation of Wettest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_17, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Driest Quarter", x = "clade", 
       y = "Precipitation of Driest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_18, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Warmest Quarter", x = "clade", 
       y = "Precipitation of Warmest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(cal_port_aus, aes(x = clade, y = CHELSA_BIOL_19, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  labs(title = "Precipitation of Coldest Quarter", x = "clade", 
       y = "Precipitation of Coldest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

########### KERNEL DENSITY PLOTS ###########

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_01, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Temperature") +
  xlab("Mean Annual Temperature [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_02, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Diurnal Range") +
  xlab("Mean Diurnal Range [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_03, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Isothermality") +
  xlab("Isothermality")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_04, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Seasonality") +
  xlab("Temperature Seasonality [standard deviation]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_05, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Max Temperature of Warmest Month") +
  xlab("Max Temperature of Warmest Month [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_06, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Min Temperature of Coldest Month") +
  xlab("Min Temperature of Coldest Month [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_07, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Annual Range") +
  xlab("Temperature Annual Range [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_08, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Wettest Quarter") +
  xlab("Mean Temperature of Wettest Quarter [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_09, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Driest Quarter") +
  xlab("Mean Temperature of Driest Quarter [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_10, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Warmest Quarter") +
  xlab("Mean Temperature of Warmest Quarter [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_11, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Coldest Quarter") +
  xlab("Mean Temperature of Coldest Quarter [°C*10]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_12, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Precipitation") +
  xlab("Mean Annual Precipitation [mm/year]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_13, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Month") +
  xlab("Precipitation of Wettest Month [mm/month]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_14, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Month") +
  xlab("Precipitation of Driest Month [mm/month]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_15, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation Seasonality") +
  xlab("Precipitation Seasonality [coefficient of variation]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_16, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Quarter") +
  xlab("Precipitation of Wettest Quarter [mm/quarter]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_17, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Quarter") +
  xlab("Precipitation of Driest Quarter [mm/quarter]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_18, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Warmest Quarter") +
  xlab("Precipitation of Warmest Quarter [mm/quarter]")

ggplot(cal_port_aus, aes(x = CHELSA_BIOL_19, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#F8766D", "#00BFC4")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Coldest Quarter") +
  xlab("Precipitation of Coldest Quarter [mm/quarter]")
