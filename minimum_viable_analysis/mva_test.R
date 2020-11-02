# save the environment to the working directory
save.image()
# clear environment
rm(list = ls())

setwd("/Users/nheaphy/Desktop/Files/Yale/research/portulaca/data/phylogenetics/portulaca_tree_test_10-28-2020")
# load the environment saved to the working directory
load(".Rdata") # appends (and overwrites) objects within the current workspace rather than 
# replacing it entirely, clear first please

library(ape)
library(ggtree)
library(phytools)

# read in tree file
phy_test = read.tree("portulaca_test_alignment_trimmed.fasta.treefile")

# plot phylogeny
ggtree(phy_test) +
  geom_tiplab(cex = 3)  +
  ggplot2::xlim(0, 0.08)

# create dataframe of species and average MAP
character <- portulaca_means %>% select(species, CHELSA_BIOL_01) %>%
  mutate(MAP = CHELSA_BIOL_01*0.1) %>%
  select(-CHELSA_BIOL_01)
character$species <- gsub(' ', '_', character$species)
write.csv(character, "character.csv", row.names = FALSE)

# map character state onto phylogeny
# from http://www.phytools.org/Cordoba2017/ex/15/Plotting-methods.html 

dotTree(phy_test, character, length=10, ftype="i")
plotTree.barplot(phy_test, character)

character <- read.csv("character.csv", header = TRUE, row.names = 1)
character <- setNames(character[, 1], rownames(character))
obj <- contMap(phy_test, character, plot = FALSE)
obj <- setMap(obj, invert=TRUE)
plot(obj, fsize = c(0.5,0.75), outline=FALSE, lwd=c(3,7), leg.txt="MAP")
