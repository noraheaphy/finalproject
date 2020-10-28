# set up
# save the environment to the working directory
save.image()
# clear environment
rm(list = ls())

setwd("/Users/nheaphy/Desktop/Files/Yale/research/portulaca/data")
# load the environment saved to the working directory
load(".Rdata") # appends (and overwrites) objects within the current workspace rather than 
               # replacing it entirely, clear first please

library(tidyverse)
library(CoordinateCleaner)
library(countrycode)
library(ggplot2)

############ CLEAN PORTULACA DATA ############

# load in portulaca gbif data
portulaca <- read.csv("portulaca_gbif_08-14-2020.csv", header = TRUE, sep = ",", 
                      na.strings = "") 

# select columns of interest
portulaca <- portulaca %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, genus, taxonRank, scientificName, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, collectionCode)

### bring in Australian Virtual Herbarium data
portulaca_avh <- read.csv("portulaca_avh_08-21-2020.csv", header = TRUE, sep = ",", 
                          na.strings = "") 

# select columns of interest
portulaca_avh <- portulaca_avh %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, 
                individualCount, occurrenceID, family, genus, taxonRank, scientificName, 
                coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode, 
                collectionCode)

# join into one dataset
portulaca <- bind_rows(portulaca, portulaca_avh)
rm(portulaca_avh)

# check for duplicates

# remove records without coordinates
portulaca <- portulaca %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(!is.na(decimalLatitude))

# remove P. oleracea and P. pilosa
oleracea <- filter(portulaca, species == "Portulaca oleracea") 
pilosa <- filter(portulaca, species == "Portulaca pilosa") 
portulaca <- setdiff(portulaca, oleracea)
portulaca <- setdiff(portulaca, pilosa) 
rm(oleracea, pilosa)

# convert country code from ISO2c to ISO3c
portulaca$countryCode <- countrycode(portulaca$countryCode, origin = "iso2c", 
                                         destination = "iso3c", warn = TRUE, nomatch = NA)

# flag problems
portulaca <- data.frame(portulaca)
flags <- clean_coordinates(x = portulaca, lon = "decimalLongitude", lat = "decimalLatitude",
                           countries = "countryCode", 
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries", "seas"))

# exclude problematic records
portulaca <- portulaca[flags$.summary,] 
rm(flags)

# remove records with low coordinate precision (>1000)
portulaca <- portulaca %>%
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters)) 

# remove unsuitable data sources (fossils, unknown, living specimens) 
table(portulaca$basisOfRecord)
portulaca <- filter(portulaca, basisOfRecord == "PRESERVED_SPECIMEN"
                    | basisOfRecord == "PreservedSpecimen") 

# filter suspicious individual counts
table(portulaca$individualCount)
portulaca <- portulaca %>%
  filter(individualCount > 0 | is.na(individualCount)) %>%
  filter(individualCount < 99 | is.na(individualCount)) 

# filter by age of records
table(portulaca$year)
# remove records from before second world war
portulaca <- portulaca %>%
  filter(year > 1945)  

# make sure taxon info is correct
table(portulaca$family) # should be all Portulacaceae
table(portulaca$genus) # should be all Portulaca
table(portulaca$taxonRank) # 1309 identified only to genus level
portulaca <- filter(portulaca, taxonRank == "GENUS" | taxonRank == "SPECIES" | 
                         taxonRank == "SUBSPECIES" | taxonRank == "genus" |
                        taxonRank == "species")

# substitute 'Portulaca L.' in for NA
portulaca_na <- filter(portulaca, is.na(species))
portulaca_fine <- setdiff(portulaca, portulaca_na)
vars <- c("Portulaca L.")
portulaca_na$species <- vars
portulaca <- bind_rows(portulaca_na, portulaca_fine)
rm(portulaca_na, portulaca_fine, vars)

# get rid of species with less than  10 coordinates
portulaca$species1 <- as.factor(portulaca$species) 
species_list <- unique(portulaca$species1)
group_by(portulaca, species1)
require(dplyr)
species_counts <- portulaca %>% count(species1)
names(species_counts) <- sub('species','species', names(species_counts))
combinedData <- full_join(portulaca, species_counts, by='species1', type='left', match='all')
portulaca <- combinedData %>%
  filter(combinedData$n >= 10)

# remove duplicates 
portulaca_l <- filter(portulaca, species == "Portulaca L.")
portulaca_sp <- setdiff(portulaca, portulaca_l)
portulaca_sp <- portulaca_sp %>% distinct(species, decimalLongitude, decimalLatitude, 
                                          .keep_all = TRUE)
portulaca <- bind_rows(portulaca_l, portulaca_sp)
rm(portulaca_l, portulaca_sp)
write.csv(portulaca, "portulaca_clean_10-08-2020.csv", row.names=F)

# save species counts for later
group_by(portulaca, species1)
require(dplyr)
portulaca_species_counts <- portulaca %>% count(species1)
write.csv(portulaca_species_counts, "portulaca_species_counts_10-08-2020.csv", 
          row.names=F)
rm(combinedData, species_counts, species_list)

# make a plot
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = portulaca, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw() # pretty good distribution of global sampling

write.csv(portulaca, "portulaca_ian_09-18-2020.csv", row.names=F)

############ CLEAN ANACAMPSEROTACEAE DATA ############

# load in anacampserotaceae data
anacamps <- read.csv("anacampserotaceae_gbif_08-14-2020.csv", header = TRUE, sep = ",", 
                     na.strings = "")

# select columns of interest
anacamps <- anacamps %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, genus, taxonRank, scientificName, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, collectionCode)

### bring in Australian Virtual Herbarium data
anacamps_avh <- read.csv("anacamps_avh_08-21-2020.csv", header = TRUE, sep = ",", 
                          na.strings = "")

# select columns of interest
anacamps_avh <- anacamps_avh %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, 
                individualCount, occurrenceID, family, genus, taxonRank, scientificName, 
                coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode, 
                collectionCode)

# join into one dataset
anacamps <- bind_rows(anacamps, anacamps_avh) 
rm(anacamps_avh)

# remove records without coordinates
anacamps <- anacamps %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(!is.na(decimalLatitude))

# convert country code from ISO2c to ISO3c
anacamps$countryCode <- countrycode(anacamps$countryCode, origin = "iso2c", 
                                     destination = "iso3c", warn = TRUE, nomatch = NA)
# investigate any errors at https://www.iban.com/country-codes

# flag problems
anacamps <- data.frame(anacamps)
flags <- clean_coordinates(x = anacamps, lon = "decimalLongitude", lat = "decimalLatitude",
                           countries = "countryCode", 
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries", "seas"))

# exclude problematic records
anacamps <- anacamps[flags$.summary,]
rm(flags)

# remove records with low coordinate precision (>1000)
anacamps <- anacamps %>%
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters))

# remove unsuitable data sources
table(anacamps$basisOfRecord)
anacamps <- filter(anacamps, basisOfRecord == "PRESERVED_SPECIMEN" |
                     basisOfRecord == "PreservedSpecimen") 

# filter suspicious individual counts
table(anacamps$individualCount)
anacamps <- anacamps %>%
  filter(individualCount > 0 | is.na(individualCount)) %>%
  filter(individualCount < 99 | is.na(individualCount)) 

# filter by age of records
table(anacamps$year)
# remove records from before second world war
anacamps <- anacamps %>%
  filter(year > 1945) 

# make sure taxon info is correct
table(anacamps$family) # some will be misclassified as Portulacaceae, that's okay
table(anacamps$taxonRank) 
anacamps <- filter(anacamps, taxonRank == "GENUS" | taxonRank == "SPECIES" | 
                      taxonRank == "SUBSPECIES" | taxonRank == "species") 

# substitute 'Genus L.' in for NA
anacamps_na <- filter(anacamps, is.na(species))
anacamps_fine <- setdiff(anacamps, anacamps_na)
vars <- c("Anacampseros L.")
anacamps_na$species <- vars
anacamps <- bind_rows(anacamps_na, anacamps_fine)
rm(anacamps_na, anacamps_fine, vars)

# remove points clearly wrong based on ArcGIS map and known distributions
write.csv(anacamps, "anacamps_arcgis_09-18-2020.csv", row.names=F)

anacamps_remove <- anacamps %>% filter(gbifID == "2819368457" | gbifID == "1258119684" |
                                       gbifID == "1211935420")
anacamps <- setdiff(anacamps, anacamps_remove)
rm(anacamps_remove)

# get rid of species with less than  10 coordinates
anacamps$species1 <- as.factor(anacamps$species) 
species_list <- unique(anacamps$species1)
group_by(anacamps, species1)
require(dplyr)
species_counts <- anacamps %>% count(species1)
names(species_counts) <- sub('species','species', names(species_counts))
combinedData <- full_join(anacamps, species_counts, by='species1', type='left', match='all')
anacamps <- combinedData %>%
  filter(combinedData$n >= 10) 
rm(combinedData, species_counts)

# remove duplicate records
anacamps <- anacamps %>% distinct(species, decimalLongitude, decimalLatitude, 
                                  .keep_all = TRUE)
write.csv(anacamps, "anacamps_clean_10-08-2020.csv", row.names=F)

# save species counts for later
group_by(anacamps, species1)
require(dplyr)
anacamps_species_counts <- anacamps %>% count(species1)
write.csv(anacamps_species_counts, "anacamps_species_counts_dedup_10-08-2020.csv", 
          row.names=F)

# make a plot
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = anacamps, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw() 

############ CLEAN CALANDRINIA DATA ############

# load in calandrinia data
calandrinia <- read.csv("calandrinia_gbif_08-14-2020.csv", header = TRUE, sep = ",", 
                        na.strings = "")

# select columns of interest
calandrinia <- calandrinia %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, genus, taxonRank, scientificName, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, collectionCode)

### bring in Australian Virtual Herbarium data
calandrinia_avh <- read.csv("calandrinia_avh_08-21-2020.csv", header = TRUE, sep = ",", 
                         na.strings = "")

# select columns of interest
calandrinia_avh <- calandrinia_avh %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, 
                individualCount, occurrenceID, family, genus, taxonRank, scientificName, 
                coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode, 
                collectionCode)

# join into one dataset
calandrinia <- bind_rows(calandrinia, calandrinia_avh) 
rm(calandrinia_avh)

# remove records without coordinates
calandrinia <- calandrinia %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(!is.na(decimalLatitude))

# convert country code from ISO2c to ISO3c
calandrinia$countryCode <- countrycode(calandrinia$countryCode, origin = "iso2c", 
                                     destination = "iso3c", warn = TRUE, nomatch = NA)

# flag problems
calandrinia <- data.frame(calandrinia)
flags <- clean_coordinates(x = calandrinia, lon = "decimalLongitude", lat = "decimalLatitude",
                           countries = "countryCode", 
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries", "seas"))

# exclude problematic records
calandrinia <- calandrinia[flags$.summary,] 
rm(flags)

# remove records with low coordinate precision (>1000 or NA)
calandrinia <- calandrinia %>%
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters)) 

# remove unsuitable data sources (fossils, unknown, living specimens) 
table(calandrinia$basisOfRecord)
calandrinia <- filter(calandrinia, basisOfRecord == "PRESERVED_SPECIMEN") 

# filter suspicious individual counts
table(calandrinia$individualCount)
calandrinia <- calandrinia %>%
  filter(individualCount > 0 | is.na(individualCount)) %>%
  filter(individualCount < 99 | is.na(individualCount)) 

# filter by age of records
table(calandrinia$year)
# remove records from before second world war
calandrinia <- calandrinia %>%
  filter(year > 1945) 

# make sure taxon info is correct
table(calandrinia$family) # should be all Montiaceae
table(calandrinia$genus) # should be all Calandrinia
table(calandrinia$taxonRank) 
calandrinia <- filter(calandrinia, taxonRank == "GENUS" | taxonRank == "SPECIES" | 
                      taxonRank == "SUBSPECIES")

# substitute 'Calandrinia L.' in for NA
calandrinia_na <- filter(calandrinia, is.na(species))
calandrinia_fine <- setdiff(calandrinia, calandrinia_na)
vars <- c("Calandrinia L.")
calandrinia_na$species <- vars
calandrinia <- bind_rows(calandrinia_na, calandrinia_fine)
rm(calandrinia_na, calandrinia_fine, vars)

# crop calandrinia distribution to only australia
write.csv(calandrinia, "calandrinia_arcgis_09-18-2020.csv", row.names=F)
calandrinia <- read.csv("calandrinia_australia.csv", header = TRUE, sep = ",", 
                        na.strings = "")
calandrinia <- calandrinia[1:16]

# get rid of species with less than 10 coordinates
calandrinia$species1 <- as.factor(calandrinia$species) 
species_list <- unique(calandrinia$species1)
group_by(calandrinia, species1)
require(dplyr)
species_counts <- calandrinia %>% count(species1)
names(species_counts) <- sub('species','species', names(species_counts))
combinedData <- full_join(calandrinia, species_counts, by='species1', type='left', match='all')
calandrinia <- combinedData %>%
  filter(combinedData$n >= 10) 
rm(combinedData, species_list, species_counts)

# remove duplicate records
calandrinia_l <- filter(calandrinia, species == "Calandrinia L.")
calandrinia_sp <- setdiff(calandrinia, calandrinia_l)
calandrinia_sp <- calandrinia_sp %>% distinct(species, decimalLongitude, decimalLatitude, 
                                              .keep_all = TRUE)
calandrinia <- bind_rows(calandrinia_l, calandrinia_sp)
rm(calandrinia_l, calandrinia_sp)
write.csv(calandrinia, "calandrinia_clean_10-08-2020.csv", row.names=F)

# save species counts for later
group_by(calandrinia, species)
require(dplyr)
calandrinia_species_counts <- calandrinia %>% count(species)
write.csv(calandrinia_species_counts, "calandrinia_species_counts_dedup_10-08-2020.csv", 
          row.names=F)

# make a plot
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = calandrinia, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw() 

############ CLEAN CACTACEAE DATA ############

# load in cactaceae data
cactaceae <- read.csv("cactaceae_gbif_10-08-2020.csv", header = TRUE, sep = ",", 
                        na.strings = "")

# select columns of interest
cactaceae <- cactaceae %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, genus, taxonRank, scientificName, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, collectionCode)

### bring in Australian Virtual Herbarium data
cactaceae_avh <- read.csv("cactaceae_avh_10-08-2020.csv", header = TRUE, sep = ",", 
                            na.strings = "")

# select columns of interest
cactaceae_avh <- cactaceae_avh %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, 
                individualCount, occurrenceID, family, genus, taxonRank, scientificName, 
                coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode, 
                collectionCode)

# join into one dataset
cactaceae <- bind_rows(cactaceae, cactaceae_avh) 
rm(cactaceae_avh)

# remove records without coordinates
cactaceae <- cactaceae %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(!is.na(decimalLatitude))

# convert country code from ISO2c to ISO3c
cactaceae$countryCode <- countrycode(cactaceae$countryCode, origin = "iso2c", 
                                       destination = "iso3c", warn = TRUE, nomatch = NA)

# flag problems
cactaceae <- data.frame(cactaceae)
flags <- clean_coordinates(x = cactaceae, lon = "decimalLongitude", lat = "decimalLatitude",
                           countries = "countryCode", 
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries", "seas"))

# exclude problematic records
cactaceae <- cactaceae[flags$.summary,] 
rm(flags)

# remove records with low coordinate precision (>1000 or NA)
cactaceae <- cactaceae %>%
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters)) 

# remove unsuitable data sources (fossils, unknown, living specimens) 
table(cactaceae$basisOfRecord)
cactaceae <- filter(cactaceae, basisOfRecord == "PRESERVED_SPECIMEN" |
                      basisOfRecord == "PreservedSpecimen") 

# filter suspicious individual counts
table(cactaceae$individualCount)
cactaceae <- cactaceae %>%
  filter(individualCount > 0 | is.na(individualCount)) %>%
  filter(individualCount < 99 | is.na(individualCount)) 

# filter by age of records
table(cactaceae$year)
# remove records from before second world war
cactaceae <- cactaceae %>%
  filter(year > 1945) 

# make sure taxon info is correct
table(cactaceae$family) 
table(cactaceae$genus) 
table(cactaceae$taxonRank) 
cactaceae <- filter(cactaceae, taxonRank == "GENUS" | taxonRank == "SPECIES" | 
                        taxonRank == "SUBSPECIES" | taxonRank == "genus" | 
                        taxonRank == "species")

# substitute 'Genus L.' in for NA
cactaceae_na <- filter(cactaceae, is.na(species))
cactaceae_fine <- setdiff(cactaceae, cactaceae_na)
vars <- paste(cactaceae_na$genus, " L.")
cactaceae_na$species <- vars
cactaceae <- bind_rows(cactaceae_na, cactaceae_fine)
rm(cactaceae_na, cactaceae_fine, vars)

# get rid of species with less than 10 coordinates
cactaceae$species1 <- as.factor(cactaceae$species) 
species_list <- unique(cactaceae$species1)
group_by(cactaceae, species1)
require(dplyr)
species_counts <- cactaceae %>% count(species1)
names(species_counts) <- sub('species','species', names(species_counts))
combinedData <- full_join(cactaceae, species_counts, by='species1', type='left', match='all')
cactaceae <- combinedData %>%
  filter(combinedData$n >= 10) 
rm(combinedData, species_list, species_counts)

# remove duplicate records
cactaceae_l <- filter(cactaceae, taxonRank == "GENUS")
cactaceae_sp <- setdiff(cactaceae, cactaceae_l)
cactaceae_sp <- cactaceae_sp %>% distinct(species, decimalLongitude, decimalLatitude, 
                                            .keep_all = TRUE)
cactaceae <- bind_rows(cactaceae_l, cactaceae_sp)
rm(cactaceae_l, cactaceae_sp)
write.csv(cactaceae, "cactaceae_clean_10-08-2020.csv", row.names=F)

# save species counts for later
group_by(cactaceae, species1)
require(dplyr)
cactaceae_species_counts <- cactaceae %>% count(species1)
write.csv(cactaceae_species_counts, "cactaceae_species_counts_dedup_10-08-2020.csv", 
          row.names=F)

# make a plot
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = cactaceae, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw() 

############ CLEAN TALINUM DATA ############

# load in calandrinia data
talinum <- read.csv("talinum_gbif_10-08-2020.csv", header = TRUE, sep = ",", 
                        na.strings = "")

# select columns of interest
talinum <- talinum %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
                gbifID, family, genus, taxonRank, scientificName, coordinateUncertaintyInMeters, year,
                basisOfRecord, institutionCode, collectionCode)

### bring in Australian Virtual Herbarium data
talinum_avh <- read.csv("talinum_avh_10-08-2020.csv", header = TRUE, sep = ",", 
                            na.strings = "")

# select columns of interest
talinum_avh <- talinum_avh %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, 
                individualCount, occurrenceID, family, genus, taxonRank, scientificName, 
                coordinateUncertaintyInMeters, year, basisOfRecord, institutionCode, 
                collectionCode)

# join into one dataset
talinum <- bind_rows(talinum, talinum_avh) 
rm(talinum_avh)

# remove records without coordinates
talinum <- talinum %>%
  filter(!is.na(decimalLongitude)) %>%
  filter(!is.na(decimalLatitude))

# convert country code from ISO2c to ISO3c
talinum$countryCode <- countrycode(talinum$countryCode, origin = "iso2c", 
                                       destination = "iso3c", warn = TRUE, nomatch = NA)

# flag problems
talinum <- data.frame(talinum)
flags <- clean_coordinates(x = talinum, lon = "decimalLongitude", lat = "decimalLatitude",
                           countries = "countryCode", 
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries", "seas"))

# exclude problematic records
talinum <- talinum[flags$.summary,] 
rm(flags)

# remove records with low coordinate precision (>1000 or NA)
talinum <- talinum %>%
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters)) 

# remove unsuitable data sources (fossils, unknown, living specimens) 
table(talinum$basisOfRecord)
talinum <- filter(talinum, basisOfRecord == "PRESERVED_SPECIMEN" |
                    basisOfRecord == "PreservedSpecimen") 

# filter suspicious individual counts
table(talinum$individualCount)
talinum <- talinum %>%
  filter(individualCount > 0 | is.na(individualCount)) %>%
  filter(individualCount < 99 | is.na(individualCount)) 

# filter by age of records
table(talinum$year)
# remove records from before second world war
talinum <- talinum %>%
  filter(year > 1945) 

# make sure taxon info is correct
table(talinum$family)
table(talinum$genus)
table(talinum$taxonRank) 
talinum <- filter(talinum, taxonRank == "GENUS" | taxonRank == "SPECIES" | 
                        taxonRank == "species")

# substitute 'Talinum L.' in for NA
talinum_na <- filter(talinum, is.na(species))
talinum_fine <- setdiff(talinum, talinum_na)
vars <- c("Talinum L.")
talinum_na$species <- vars
talinum <- bind_rows(talinum_na, talinum_fine)
rm(talinum_na, talinum_fine, vars)

# get rid of species with less than 10 coordinates
talinum$species1 <- as.factor(talinum$species) 
species_list <- unique(talinum$species1)
group_by(talinum, species1)
require(dplyr)
species_counts <- talinum %>% count(species1)
names(species_counts) <- sub('species','species', names(species_counts))
combinedData <- full_join(talinum, species_counts, by='species1', type='left', match='all')
talinum <- combinedData %>%
  filter(combinedData$n >= 10) 
rm(combinedData, species_list, species_counts)

# remove duplicate records
talinum_l <- filter(talinum, species == "Talinum L.")
talinum_sp <- setdiff(talinum, talinum_l)
talinum_sp <- talinum_sp %>% distinct(species, decimalLongitude, decimalLatitude, 
                                              .keep_all = TRUE)
talinum <- bind_rows(talinum_l, talinum_sp)
rm(talinum_l, talinum_sp)
write.csv(talinum, "talinum_clean_10-09-2020.csv", row.names=F)

# save species counts for later
group_by(talinum, species1)
require(dplyr)
talinum_species_counts <- talinum %>% count(species1)
write.csv(talinum_species_counts, "talinum_species_counts_dedup_10-08-2020.csv", 
          row.names=F)

# make a plot
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = talinum, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw() 
