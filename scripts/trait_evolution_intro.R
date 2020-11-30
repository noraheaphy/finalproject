#### Sample code from Martha Munoz, summer E&EB seminar 

getwd() ## allows you to see where your current working directory is
setwd("/Users/marthamunoz/Desktop") ## allows you to change the working directory

### Load a few phylogenetic and some non-phylogenetic packages. If you don't have these installed, you'll need to install them first
library(phytools)
library(ape)
library(geiger)
library(caper)
library(Rmpfr)
library(OUwie)
library(qpcR)


###
### Load the Anole Phylogenetic Tree
### 

##Load tree
anole.tree<-read.nexus("poe.tre")
plotTree(anole.tree) # this tree contains way more species than are present in our dataset, so we will have to
## prune the tree down to our species of interest.

# Import the Anolis trait data
tb_data<-read.csv("tb_anoles_eeb.csv", header=1)
head(tb_data) # shows you the first 6 rows of your inputted data (allows you to check it worked ok)
rownames(tb_data)<-tb_data$species ## tells R to name each row of your dataset according to its 
## corresponding value in the "species" column. By using species names to identify rows, we will be able
## to match the trait data in this file with species names on the phylogeny.
head(tb_data) # You should now see that the row names have been modified.
names(tb_data) ## This function lets you know your column names, which is very handy as we move on

### PRUNE THE TREE to just include the species for which you have trait data
anolespecies<-row.names(tb_data) # creates an object with all your species names
anolespecies ### 91 species in your trait data set
anole.tree$tip.label ## the unpruned anole tree has hundreds of species in it (so we have lots of tips to prune)

pruned.anole.tree<-drop.tip(anole.tree, setdiff(anole.tree$tip.label, anolespecies)) ## this function
# prunes the tree to just those species in the 'anolespecies' object
plotTree(pruned.anole.tree) # now you can see that the tree has been pruned (but the unpruned tree hasn't been deleted.
# You simply created a new object that contains the pruned tree.)
pruned.anole.tree$tip.label ## 91 species in the pruned tree. We're good to go!

### Ensure that the trait data are in the same species order as species identity in the tree
anole.data.ordered<-tb_data[pruned.anole.tree$tip.label,] # this puts your data into the same order as the tips on the tree

### isolate your trait of interest into its own object
names(anole.data.ordered) ## from this you can see that 'tb' is column 2 of the dataset
tb<-anole.data.ordered[,2]
names(tb)<-row.names(anole.data.ordered)
tb
### now you have an object with your species trait data that is in the same order as your tree
landmass<-anole.data.ordered[,3]
names(landmass)<-row.names(anole.data.ordered)
landmass

## Now, let's visualize tb and landmass by mapping them onto the anole phylogeny
contMap(pruned.anole.tree,tb)
contMap(pruned.anole.tree,landmass)

### shows you the variation in the traits among all species in the tree

### Next, let's estimate phylogenetic signal
## Phylogenetic signal describes the tendency for related species to resemble each other 
## more than species drawn at random from the same tree. 
## The amount of "phylogenetic signal" in the trait data essentially tells us how much of this
## observed trait variation is simply due to time since divergence 

### There are many ways to compute phylogenetic signal.
### I use the phylosig function in the R package phytools 
phylosig(pruned.anole.tree, tb, method="K")
## The method above uses Blomberg's K to estimate phylogenetic signal. Values of K range from 0 to infinity, with an expected value of 1.0 under Brownian motion. 
## Values of K<1.0 describe data with less phylogenetic signal than expected, and values of K>1.0 describe data with 
## greater phylogenetic signal than expected due to chance.
## There are other statistics for measuring phylogenetic signal, like Pagel's lambda.

## OK, we've visualized our traits and we've gathered that species appear a bit more different than expected than simply due to chance.
## Let's take this one step further to test our directional hypothesis: That heat tolerance evolution differs between mainland and island environments.
## We do this by reconstructing habitat onto the anole phylogeny, and fitting a series of evolutionary models to the trait data based on those reconstructions
## of geography. Then, we're going to see how well the models 'explain' the data (adjusting for the number of parameters in the model).

library(phytools)
library(Rmpfr)
library(OUwie)

## make simmap
#### Running OUwie

habitat <- as.matrix(anole.data.ordered)[, "landmass"]
habitat
trees_habitat<-make.simmap(pruned.anole.tree,habitat, nsim=10)
trees_habitat
## Here I've simulated landmass onto the anole phylogeny 10 times. 
## Normally, you'd want to do this hundreds of times, but the computation time increases
## with number of simulations, so I've simplified it to 10 times.

Tb_OUwie <- data.frame(Genus_species = rownames(anole.data.ordered), Reg = habitat, X = as.numeric(tb))
Tb_OUwie

# Let's take a pause from R so I can walk you through these models again in Keynote
BM1_Tb<-lapply(trees_habitat,OUwie,data=Tb_OUwie,model="BM1",simmap.tree=TRUE)
BMS_Tb<-lapply(trees_habitat,OUwie,data=Tb_OUwie,model="BMS",simmap.tree=TRUE)
OU1_Tb<-lapply(trees_habitat,OUwie,data=Tb_OUwie,model="OU1",simmap.tree=TRUE)
OUM_Tb<-lapply(trees_habitat,OUwie,data=Tb_OUwie,model="OUM",simmap.tree=TRUE)
OUMV_Tb<-lapply(trees_habitat,OUwie,data=Tb_OUwie,model="OUMV",simmap.tree=TRUE)

## Estimate the fit of the model to the data using AICc score
meanaicc_BM1_Tb<-t(sapply(BM1_Tb,function(x) x$AICc))
meanaicc_BM1_Tb ## We ran OUwie across each of the 10 stochastic character maps
## that we built in an earlier step. So, for the single-rate BM model, we have 10 AICc scores.
## We take the mean of these to get the average support for the BM1 model.
mean(meanaicc_BM1_Tb) # 172.3082 (average AIC score across the 10 stochastic charactermaps)

meanaicc_BMS_Tb<-t(sapply(BMS_Tb,function(x) x$AICc))
meanaicc_OU1_Tb<-t(sapply(OU1_Tb,function(x) x$AICc))
meanaicc_OUM_Tb<-t(sapply(OUM_Tb,function(x) x$AICc))
meanaicc_OUMV_Tb<-t(sapply(OUMV_Tb,function(x) x$AICc))


### Calculate AIC weights for your AIC scores.
### BM1, BMS, OU1, OUM, OUMV <- in that order
library(qpcR)
z<-c(mean(meanaicc_BM1_Tb), mean(meanaicc_BMS_Tb), mean(meanaicc_OU1_Tb), mean(meanaicc_OUM_Tb), mean(meanaicc_OUMV_Tb))
akaike.weights(z)

### Estimate mean theta for island and mainland lizards.

theta_OUM_tb<-t(sapply(OUM_Tb,function(x) x$theta))
theta_OUM_tb
mean(theta_OUM_tb[,1]) ### island theta 29.7
mean(theta_OUM_tb[,2]) #### mainland theta 27.4 
#### optimal value for body temperature ~2C warmer on islands than on mainland


