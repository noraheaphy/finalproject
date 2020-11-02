# Minimum Viable Analysis
## November 2, 2020

### Steps of project

**1. Climate data aquisition:** I will download all available specimen collection records for Portulaca, Anacampserotaceae, Cactaceae, Talinum, and Calandrinia from the Global Biodiversity Information Facility (GBIF), supplemented with localities from other databases such as iDigBio and the Australian Virtual Herbarium. I will then thoroughly curate these records using the R package Coordinate Cleaner to remove erroneous localities, and I will verify taxonomic names to the fullest extent possible using the most plausible published phylogenies of these lineages. I will also exclude records from P. oleracea, P. pilosa, T. paniculatum, and T. fruticosum, as these are globally widespread weeds that would necessarily skew analyses of climatic niche. I will then download environmental data in the form of global raster layers from CHELSA and the Australian Bureau of Meteorology, supplementing the standard 19 bioclimatic variables with data on potential evapotranspiration and aridity index. I will then extract environmental data for each specimen locality in ArcGIS Pro. All analyses will be conducted over a spatial resolution of 1 km<sup>2</sup> under the geodetic datum WGS84.

**2. Molecular data acquisition:** I will obtain the full data matrix of genes and taxa assembled by Ocampo & Columbus (2012), comprising 80 samples of Portulaca, representing 59 species, 10 subspecies, 3 cultivars, and 3 outgroups from Cactaceae, Talinaceae, and Montiaceae. The matrix includes nuclear ribosomal DNA loci (ITS, comprising ITS1, the 5.8S gene, and ITS2) and chloroplast DNA loci (protein-coding *ndhF*, *trnT-psbD* intergenic spacer, and *ndhA* intron. The P. oleracea species complex, which is taxonomically complicated and contested, is considered at the subspecies level. I will obtain the full baits data matrix for Portullugo from the Edwards Lab and subset this dataset to the Anacampserotaceae taxa and a few outgroups from Cactaceae and Talinaceae. I will then trim the taxa list to only include those for which I have both climate data and molecular data. 

**3. Phylogenetic inference:** I will use these two data matrices to infer phylogenies for Anacampserotaceae and Portulaca separately via Bayesian MCMC methods in RevBayes. I will estimate edge lengths independently, and then based on the preponderance of evidence that these two groups are sister clades, I will graft the trees together, time calibrate branches accordingly, and test time calibrations by adding jitter into the sensitivity analysis. The support for the tree will be assessed based on the Bayesian posterior probabilities for each node. I will also retain the entire posterior distribution for use in later analyses.

**4. Time calibration:** I will time calibrate the grafted phylogeny in RevBayes using the aligned matrices and a list of extant taxa for which the minimum age has been clamped to 0. I will time calibrate branches based on a relaxed clock model, as described in Warnock et al. (2019). 

**5. Ancestral state reconstruction:** I will calculate species level mean and variance for each environmental variable for all taxa in the phylogeny, and then using the R packages phytools, ape, and ggtree, I will map these climate character states onto the tips of the phylogeny, infer the character states of internal nodes and reconstruct the ancestral states for the base of the Anacampserotaceae clade and the base of the Portulaca clade. I will use a Brownian motion model to perform a PIC reconstruction of the entire tree.

**6. Hypothesis test on posterior distribution:** Finally, I will perform a hypothesis test comparing two means to determine if the difference in environmental variables reconstructed at the ancestral nodes of Anacampserotaceae and Portulaca across the posterior distribution of trees is statistically significant. By examining this difference in means across the posterior distribution of trees, I will be able to assess the sensitivity of my results to different topologies and time calibrations.

### Steps completed for Minimum Viable Analysis

I downloaded 1 gene sequence across all the Portulaca taxa included in the Ocampo & Columbus (2012) phylogeny using NCBI BLAST. I pruned this alignment to only include taxa for which I had climate data, and then I used IQ-TREE to infer a mock phylogeny (Figure 1).

IMAGE HERE

In R, I used the phytools package to map species Mean Annual Temperature character data onto the Portulaca phylogeny based on the methods in Revell (2017) (Figure 2).

IMAGE HERE
