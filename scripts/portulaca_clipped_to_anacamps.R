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

# load in datasets
port_clipped <- read.csv("port_clipped_to_ana_11-29-2020.csv", header = TRUE, sep = ",", 
                           na.strings = "") 
anacamps <- read.csv("all_localities_extracted_clean_11-29-2020.csv", header = TRUE, sep = ",",
                     na.strings = "") %>%
  filter(clade == "Anacampserotaceae")

# remove everything with a NULL value
port_clipped <- filter(port_clipped, CHELSA_BIOL_01 != "NULL" & 
                                   CHELSA_BIOL_02 != "NULL" &
                                   CHELSA_BIOL_03 != "NULL" & 
                                   CHELSA_BIOL_04 != "NULL" & 
                                   CHELSA_BIOL_05 != "NULL" & 
                                   CHELSA_BIOL_06 != "NULL" & 
                                   CHELSA_BIOL_07 != "NULL" & 
                                   CHELSA_BIOL_08 != "NULL" & 
                                   CHELSA_BIOL_09 != "NULL" & 
                                   CHELSA_BIOL_10 != "NULL" & 
                                   CHELSA_BIOL_11 != "NULL" & 
                                   CHELSA_BIOL_12 != "NULL" & 
                                   CHELSA_BIOL_13 != "NULL" & 
                                   CHELSA_BIOL_14 != "NULL" & 
                                   CHELSA_BIOL_15 != "NULL" & 
                                   CHELSA_BIOL_16 != "NULL" &
                                   CHELSA_BIOL_17 != "NULL" & 
                                   CHELSA_BIOL_18 != "NULL" & 
                                   CHELSA_BIOL_19 != "NULL")

# put all columns in right format
port_clipped$species <- as.factor(port_clipped$species)
port_clipped$clade <- as.factor(port_clipped$clade)
anacamps$species <- as.factor(anacamps$species)
anacamps$clade <- as.factor(anacamps$clade)

# transform CHELSA_BIOL_01 to MAT
port_clipped <- port_clipped %>% mutate(MAT = CHELSA_BIOL_01*0.1)
anacamps <- anacamps %>% mutate(MAT = CHELSA_BIOL_01*0.1)

# combine to single dataset and save
port_ana_clipped <- bind_rows(port_clipped, anacamps)
write.csv(port_ana_clipped, "port_ana_clipped_11-29-2020.csv", row.names = F)

# subset to only clade and environmental variables
port_ana_clipped <- port_ana_clipped %>% select(clade, CHELSA_BIOL_01:MAT)

########### MANOVA ###########

responses <- paste(colnames(port_ana_clipped)[2:20], collapse = ",")
myformula <- as.formula(paste0("cbind(", responses ,") ~ clade" ))
speciesMAN <- manova(myformula, data = port_ana_clipped) 
summary(speciesMAN, test="Wilks") 
summary.aov(speciesMAN) 

########### BIPLOTS ###########

ggplot(port_ana_clipped, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 0.5) + 
  scale_color_manual(values = c("Anacampserotaceae" = "red", "Portulaca" = "lightblue")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

ggplot(port_ana_clipped, aes(x = MAT, y = CHELSA_BIOL_12, color = clade)) +
  geom_point(size = 0.5) + 
  scale_color_manual(values = c("Anacampserotaceae" = "lightblue", "Portulaca" = "red")) +
  labs(title = "MAT vs. MAP", x = "Mean Annual Temperature (degrees C)", 
       y = "Mean Annual Precipitation (mm/year)")

########### KERNEL DENSITY PLOTS ###########

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_01, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Temperature") +
  xlab("Mean Annual Temperature [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_02, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Diurnal Range") +
  xlab("Mean Diurnal Range [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_03, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Isothermality") +
  xlab("Isothermality")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_04, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Seasonality") +
  xlab("Temperature Seasonality [standard deviation]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_05, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Max Temperature of Warmest Month") +
  xlab("Max Temperature of Warmest Month [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_06, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Min Temperature of Coldest Month") +
  xlab("Min Temperature of Coldest Month [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_07, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Temperature Annual Range") +
  xlab("Temperature Annual Range [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_08, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Wettest Quarter") +
  xlab("Mean Temperature of Wettest Quarter [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_09, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Driest Quarter") +
  xlab("Mean Temperature of Driest Quarter [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_10, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Warmest Quarter") +
  xlab("Mean Temperature of Warmest Quarter [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_11, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Temperature of Coldest Quarter") +
  xlab("Mean Temperature of Coldest Quarter [°C*10]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_12, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Mean Annual Precipitation") +
  xlab("Mean Annual Precipitation [mm/year]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_13, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Month") +
  xlab("Precipitation of Wettest Month [mm/month]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_14, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Month") +
  xlab("Precipitation of Driest Month [mm/month]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_15, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation Seasonality") +
  xlab("Precipitation Seasonality [coefficient of variation]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_16, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Wettest Quarter") +
  xlab("Precipitation of Wettest Quarter [mm/quarter]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_17, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Driest Quarter") +
  xlab("Precipitation of Driest Quarter [mm/quarter]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_18, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Warmest Quarter") +
  xlab("Precipitation of Warmest Quarter [mm/quarter]")

ggplot(port_ana_clipped, aes(x = CHELSA_BIOL_19, y = ..scaled.., fill = clade)) + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  geom_density(alpha = 0.5) + 
  ggtitle("Precipitation of Coldest Quarter") +
  xlab("Precipitation of Coldest Quarter [mm/quarter]")

########### BOX PLOTS ###########

# box plots with p values
my_comparisons <- list(c("Portulaca", "Anacampserotaceae"))

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_01, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Annual Temperature", x = "clade", 
       y = "Mean Annual Temperature [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_02, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Diurnal Range", x = "clade", 
       y = "Mean Diurnal Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_03, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Isothermality", x = "clade", 
       y = "Isothermality") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_04, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Temperature Seasonality", x = "clade", 
       y = "Temperature Seasonality [standard deviation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_05, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Max Temperature of Warmest Month", x = "clade", 
       y = "Max Temperature of Warmest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_06, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Min Temperature of Coldest Month", x = "clade", 
       y = "Min Temperature of Coldest Month [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_07, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Temperature Annual Range", x = "clade", 
       y = "Temperature Annual Range [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_08, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Temperature of Wettest Quarter", x = "clade", 
       y = "Mean Temperature of Wettest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_09, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Temperature of Driest Quarter", x = "clade", 
       y = "Mean Temperature of Driest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_10, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Temperature of Warmest Quarter", x = "clade", 
       y = "Mean Temperature of Warmest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_11, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Temperature of Coldest Quarter", x = "clade", 
       y = "Mean Temperature of Coldest Quarter [°C*10]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_12, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Mean Annual Precipitation", x = "clade", 
       y = "Mean Annual Precipitation [mm/year]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_13, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Wettest Month", x = "clade", 
       y = "Precipitation of Wettest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_14, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Driest Month", x = "clade", 
       y = "Precipitation of Driest Month [mm/month]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_15, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation Seasonality", x = "clade", 
       y = "Precipitation Seasonality [coefficient of variation]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_16, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Wettest Quarter", x = "clade", 
       y = "Precipitation of Wettest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_17, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Driest Quarter", x = "clade", 
       y = "Precipitation of Driest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_18, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Warmest Quarter", x = "clade", 
       y = "Precipitation of Warmest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

ggplot(port_ana_clipped, aes(x = clade, y = CHELSA_BIOL_19, fill = clade)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("#00BFC4", "#F8766D")) +
  labs(title = "Precipitation of Coldest Quarter", x = "clade", 
       y = "Precipitation of Coldest Quarter [mm/quarter]") +
  stat_compare_means(comparisons = my_comparisons)

