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

# extract portulaca only
portulaca <- chelsa_localities %>% filter(clade == "Portulaca") %>%
  select(species, CHELSA_BIOL_01:CHELSA_BIOL_19) %>%
  mutate(MAT = CHELSA_BIOL_01*0.1)

# get species counts
portulaca$species <- as.factor(portulaca$species) 
species_counts_portulaca <- portulaca %>% group_by(species) %>% 
  count(species) 

ggplot(portulaca, aes(x = species, y = MAT)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Mean Annual Temperature of Portulaca Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Temperature (°C)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_portulaca$species, species_counts_portulaca$n))

# now extract anacampserotaceae
anacamps <- chelsa_localities %>% filter(clade == "Anacampserotaceae") %>%
  select(species, CHELSA_BIOL_01:CHELSA_BIOL_19) %>%
  mutate(MAT = CHELSA_BIOL_01*0.1)

# get species counts
anacamps$species <- as.factor(anacamps$species) 
species_counts_anacamps <- anacamps %>% group_by(species) %>% 
  count(species)

ggplot(anacamps, aes(x = species, y = MAT)) +
  geom_boxplot(fill = "red") +
  labs(title = "Mean Annual Temperature of Anacampserotaceae Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Temperature (°C)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_anacamps$species, species_counts_anacamps$n))

# now extract calandrinia for australia
calandrinia <- cal_port_aus %>% filter(clade == "Calandrinia") %>%
  select(species, CHELSA_BIOL_01:CHELSA_BIOL_19) %>%
  mutate(MAT = CHELSA_BIOL_01*0.1)

# get species counts
calandrinia$species <- as.factor(calandrinia$species) 
species_counts_calandrinia <- calandrinia %>% group_by(species) %>% 
  count(species)

ggplot(calandrinia, aes(x = species, y = MAT)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Mean Annual Temperature of Australian Calandrinia Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Temperature (°C)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_calandrinia$species, 
                                  species_counts_calandrinia$n))

# repeat portulaca but only for australia
portulaca_aus <- cal_port_aus %>% filter(clade == "Portulaca") %>%
  select(species, CHELSA_BIOL_01:CHELSA_BIOL_19) %>%
  mutate(MAT = CHELSA_BIOL_01*0.1)

# get species counts
portulaca_aus$species <- as.factor(portulaca_aus$species) 
species_counts_portulaca_aus <- portulaca_aus %>% group_by(species) %>% 
  count(species)
  
ggplot(portulaca_aus, aes(x = species, y = MAT)) +
  geom_boxplot(fill = "turquoise") +
  labs(title = "Mean Annual Temperature of Australian Portulaca Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Temperature (°C)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_portulaca_aus$species, 
                                  species_counts_portulaca_aus$n))

# make scatterplots to compare Portulaca and Anacampserotaceae
portulaca_means <- portulaca %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Portulaca", MAT = CHELSA_BIOL_01*0.1)

anacamps_means <- anacamps %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Anacampserotaceae", MAT = CHELSA_BIOL_01*0.1)

port_ana_means <- bind_rows(portulaca_means, anacamps_means)

ggplot(port_ana_means, aes(x = species, y = MAT, col = clade)) +
  geom_point() +
  xlab("Species") +
  ylab ("Mean Annual Temperature (°C)") +
  ggtitle("Mean Annual Temperature for Anacampserotaceae and Portulaca Species") +
  facet_wrap( ~ clade, scales = "free_x") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5))

# make scatterplots to compare Portulaca and Calandrinia in Australia
calandrinia_means <- calandrinia %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Calandrinia", MAT = CHELSA_BIOL_01*0.1)

port_aus_means <- portulaca_aus %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Portulaca", MAT = CHELSA_BIOL_01*0.1)

cal_port_means <- bind_rows(calandrinia_means, port_aus_means)

ggplot(cal_port_means, aes(x = species, y = MAT, col = clade)) +
  geom_point() +
  xlab("Species") +
  ylab ("Mean Annual Temperature (°C)") +
  ggtitle("Mean Annual Temperature for Australian Calandrinia and Portulaca Species") +
  facet_wrap( ~ clade, scales = "free_x") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5))


######## same thing but with MAT

portulaca <- portulaca %>% mutate(MAP = CHELSA_BIOL_12 * 0.1)

ggplot(portulaca, aes(x = species, y = MAP)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Mean Annual Precipitation of Portulaca Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Precipitation (kg/m^2)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_portulaca$species, species_counts_portulaca$n))

anacamps <- anacamps %>% mutate(MAP = CHELSA_BIOL_12 * 0.1)

ggplot(anacamps, aes(x = species, y = MAP)) +
  geom_boxplot(fill = "red") +
  labs(title = "Mean Annual Precipitation of Anacampserotaceae Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Precipitation (kg/m^2)") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_anacamps$species, species_counts_anacamps$n))

calandrinia <- calandrinia %>% mutate(MAP = CHELSA_BIOL_12 * 0.1)

ggplot(calandrinia, aes(x = species, y = MAP)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Mean Annual Precipitation of Australian Calandrinia Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Precipitation (kg/m^2") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_calandrinia$species, 
                                  species_counts_calandrinia$n))

portulaca_aus <- portulaca_aus %>% mutate(MAP = CHELSA_BIOL_12 * 0.1)

ggplot(portulaca_aus, aes(x = species, y = MAP)) +
  geom_boxplot(fill = "turquoise") +
  labs(title = "Mean Annual Precipitation of Australian Portulaca Species", 
       x = paste("species (and number of occurrences)"), 
       y = "Mean Annual Precipitation (kg/m^2") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  scale_x_discrete(labels = paste(species_counts_portulaca_aus$species, 
                                  species_counts_portulaca_aus$n))

portulaca_means <- portulaca %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Portulaca", MAT = CHELSA_BIOL_01*0.1, MAP = CHELSA_BIOL_12*0.1)

anacamps_means <- anacamps %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Anacampserotaceae", MAT = CHELSA_BIOL_01*0.1, MAP = CHELSA_BIOL_12*0.1)

port_ana_means <- bind_rows(portulaca_means, anacamps_means)

ggplot(port_ana_means, aes(x = species, y = MAP, col = clade)) +
  geom_point() +
  xlab("Species") +
  ylab ("Mean Annual Precipitation (kg/m^2)") +
  ggtitle("Mean Annual Precipitation for Anacampserotaceae and Portulaca Species") +
  facet_wrap( ~ clade, scales = "free_x") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5))

calandrinia_means <- calandrinia %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Calandrinia", MAT = CHELSA_BIOL_01*0.1, MAP = CHELSA_BIOL_12*0.1)

port_aus_means <- portulaca_aus %>% group_by(species) %>% 
  summarize(across(CHELSA_BIOL_01:CHELSA_BIOL_19, mean)) %>%
  mutate(clade = "Portulaca", MAT = CHELSA_BIOL_01*0.1, MAP = CHELSA_BIOL_12*0.1)

cal_port_means <- bind_rows(calandrinia_means, port_aus_means)

ggplot(cal_port_means, aes(x = species, y = MAP, col = clade)) +
  geom_point() +
  xlab("Species") +
  ylab ("Mean Annual Precipitation (kg/m^2") +
  ggtitle("Mean Annual Precipitation for Australian Calandrinia and Portulaca Species") +
  facet_wrap( ~ clade, scales = "free_x") +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5))
