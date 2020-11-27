# Phylogenetic Biology - Final Project

## Climate niche evolution in C4-CAM Portulaca and closely related C3-CAM lineages

![Portullugo Intro](https://github.com/noraheaphy/finalproject/blob/master/figures/portullugo_intro_photos.png)

### Background

C4 and CAM are two photosynthetic pathways that have evolved from C3 photosynthesis hundreds of times independently over the last 30 million years (Figure 1). While biochemically similar, they are understood to represent two distinct ecological adaptations. The C4 pathway confers high photosynthetic rates, allowing C4 plants to live in hot temperatures and high light environments, while the CAM pathway confers high water use efficiency and drought tolerance, allowing CAM plants to live in arid regions (Edwards and Ogburn, 2012). There are a number of anatomical and ecological factors that would lead us to expect CAM and C4 to be mutually exclusive; characteristics favorable to evolving one pathway would seemingly disadvantage the other pathway. However, the purslane lineage (Portulaca) is able to operate both CAM and C4 cycles in a single leaf and is the only plant known to display this unique photosynthetic combination (Ferrari et al. 2019). Portulaca likely had a facultative CAM ancestor that subsequently evolved a C4 cycle at least three separate times while maintaining its CAM capabilities (Guralnick et al. 2008). 

![A Brief History of Photosynthesis](https://github.com/noraheaphy/finalproject/blob/master/figures/a_brief_history_Edwards2019.png)
*Figure 1. (a) Distribution of carbon concentrating mechanisms in the angiosperm phylogeny, showing multiple origins of CAM and C4 as well as phylogenetic clustering in certain lineages. (b) C4 and CAM biomolecular pathways.*

For this project, I will investigate how evolving C4-CAM photosynthesis affected the climate niche evolution of Portulaca in comparison to two closely related lineages: Calandrinia, a C3+CAM clade in Montiaceae, and Anacampserotaceae, Portulaca’s sister lineage, which contains facultative and constitutive CAM species but no C4 plants. Despite their different photosynthetic pathways, these plants are similar in many respects, including growth form, degree of succulence, herbaceousness, and annual growth cycle, making them a useful case study for examining the ecological selection pressures that drove the different lineages to evolve CAM, C3, C4, or some combination thereof (Ocampo and Columbus, 2012). The climate niche comparison between Portulaca and Anacampserotaceae will be global, in order to take into account the full ranges of these clades, while the comparison between Portulaca and Calandrinia will be limited to Australia, where highly accurate locality data is available, in an attempt to balance the inevitable errors that accumulate in biodiversity databases like GBIF. Using environmental layers and species occurrence data, I will infer the ecological consequences of evolving C4+CAM, C3+CAM, or full CAM photosynthesis from a shared ancestral C3+CAM phenotype (Figure 2). As outgroups, I will also incorporate climatic, locality, and phylogenetic data for Cactaceae (strong CAM) and Talinum (C3-CAM), which form a clade with Anacampserotaceae and Portulacaceae (APCT). I hypothesize that evolving C4 shifted the ecological range of Portulaca into warmer and wetter environments, perhaps enabling the lineage to expand into a wider range of climatic conditions than its CAM and C3+CAM relatives. 

![Ecological Consequences of Evolving C4-CAM](https://github.com/noraheaphy/finalproject/blob/master/figures/ecological_consequences_map.png)
*Figure 2. Phylogeny of Portullugo groups used in analysis, with Anacampserotaceae and Portulaca's shared C3-CAM ancestor marked in red. Global distributions of curated records downloaded from GBIF are shown for Calandrinia, Anacampserotaceae, and Portulaca.*

The delineation of species and clades within Portulaca and its sister groups are not well established. However, a phylogenetic perspective is critical to understanding the ecological implications of evolving C4-CAM photosynthesis as well as, more broadly, understanding how selection forces and genetic or biophysical constraints enable global convergent evolution of highly complex traits. Portulaca’s unique C4-CAM photosynthesis contradicts previous hypotheses that ecological and functional selection factors drive the evolution of CAM and C4 along predominantly separate trajectories, as does the presence of both CAM species and C4 species in many major clades. A more complete understanding of Portulaca as a model system for studying the evolution and ecological implications of CAM and C4 would further our knowledge of how organisms can evolve complex traits convergently and could eventually allow researchers to bioengineer both photosynthetic syndromes into a single crop, conferring drought tolerance and high productivity simultaneously and enabling agriculture in regions whose food security is threatened by climate change.

### Methods

**1. Climate data acquisition**
I have downloaded all available specimen collection records for Portulaca, Anacampserotaceae, Cactaceae, Talinum, and Calandrinia from the Global Biodiversity Information Facility (GBIF), supplemented with localities the Australian Virtual Herbarium. I have thoroughly curated these records using the R package [Coordinate Cleaner](https://github.com/ropensci/CoordinateCleaner) to remove erroneous localities and verified taxonomic names to the fullest extent possible using the most plausible published phylogenies of these lineages. I have also excluded records from P. oleracea, P. pilosa, T. paniculatum, and T. fruticosum, as these are globally widespread weeds that would necessarily skew analyses of climatic niche. I downloaded environmental data in the form of global raster layers from [CHELSA](https://chelsa-climate.org/bioclim/). These 19 standard bioclimatic variables are shown in Table 1. I then extracted environmental data for each specimen locality in ArcGIS Pro. All analyses were conducted over a spatial resolution of 1 km<sup>2</sup> under the geodetic datum WGS84.

| Variable name | Bioclimatic variable | Units |
|--------------|----------------------|-------|
| Bio1 | Annual Mean Temperature | &deg;C * 10 |
| Bio2 | Mean Diurnal Range | &deg;C |
| Bio3 | Isothermality | NA |
| Bio4 | Temperature Seasonality | standard deviation |
| Bio5 | Max Temperature of Warmest Month | &deg;C * 10 |
| Bio6 | Min Temperature of Coldest Month | &deg;C * 10 |
| Bio7 | Temperature Annual Range | &deg;C * 10 |
| Bio8 | Mean Temperature of Wettest Quarter | &deg;C * 10 |
| Bio9 | Mean Temperature of Driest Quarter | &deg;C * 10 |
| Bio10 | Mean Temperature of Warmest Quarter | &deg;C * 10 |
| Bio11 | Mean Temperature of Coldest Quarter | &deg;C * 10 |
| Bio12 | Annual Precipitation | mm/year |
| Bio13 | Precipitation of Wettest Month | mm/month |
| Bio14 | Precipitation of Driest Month | mm/month |
| Bio15 | Precipitation Seasonality | coefficient of variation |
| Bio16 | Precipitation of Wettest Quarter | mm/quarter |
| Bio17 | Precipitation of Driest Quarter | mm/quarter |
| Bio18 | Precipitation of Warmest Quarter | mm/quarter |
| Bio19 | Precipitation of Wettest Quarter | mm/quarter |

*Table 1. Standard CHELSA bioclimatic variables. More information on this dataset is available at Karger, et al. 2017.*

**2. Molecular data acquisition**
I will obtain the full data matrix of genes and taxa assembled by Ocampo & Columbus (2012), comprising 80 samples of Portulaca, representing 59 species, 10 subspecies, 3 cultivars, and 3 outgroups from Cactaceae, Talinaceae, and Montiaceae. The matrix includes nuclear ribosomal DNA loci (ITS, comprising ITS1, the 5.8S gene, and ITS2) and chloroplast DNA loci (protein-coding ndhF, trnT-psbD intergenic spacer, and ndhA intron. The P. oleracea species complex, which is taxonomically complicated and contested, is considered at the subspecies level. I will obtain the full baits data matrix for Portullugo from the Edwards Lab and subset this dataset to the Anacampserotaceae taxa and a few outgroups from Cactaceae and Talinaceae.

**3. Phylogenetic inference** 
I will use these two data matrices to infer phylogenies for Anacampserotaceae and Portulaca separately via Bayesian MCMC methods in RevBayes. A major obstacle to using phylogenetic comparative methods across the APCT clade is that the phylogenies described above were constructed using different forms of data (transcription enrichment, whole-plastome sequencing, PCR, etc). Topologies can be combined relatively easily, but generating meaningful edge lengths is more complicated. Therefore, I will estimate edge lengths independently, and then based on the preponderance of evidence that these two groups are sister clades, I will graft the trees together, calibrate edge lengths accordingly, and test the calibrations by adding jitter into the sensitivity analysis. The support for the tree will be assessed based on the Bayesian posterior probabilities for each node. I will also retain the entire posterior distribution for use in later analyses. However, given time constraints, I am currently working with completed versions of the Ocampus & Columbus (2012) and Moore et al. (2018) phylogenies for Portulaca and Anacampserotaceae respectively that were previously inferred by members of the Edwards Lab (Figure 3).

![Portullugo Phylogeny from Moore et al. 2018](https://github.com/noraheaphy/finalproject/blob/master/figures/portullugo_phylo_Moore2018.png)
*Figure 3. Consensus tree generated for Portullugo by Moore, et al. 2018. Relationships between all major clades are well-supported (>95% bootstrap) in both coalescent (ASTRAL) and concatenated (RAxML) species trees.*

**4. Ancestral state reconstruction**
I will calculate species level mean and variance for each environmental variable for all taxa in the phylogeny, and then using the R packages phytools, ape, and ggtree, I will map these climate character states onto the tips of the phylogeny, infer the character states of internal nodes and reconstruct the ancestral states for the base of the Anacampserotaceae clade and the base of the Portulaca clade. I will use a Brownian motion model to perform a PIC reconstruction of the entire tree.

## References

1. Edwards, E.J. and Ogburn, R.M. 2012. Angiosperm responses to a low-CO2 world: CAM and C4 photosynthesis as parallel evolutionary trajectories. International Journal of Plant Sciences 173(6), 724-733. DOI: https://doi.org/10.1086/666098  

2. Ferrari, R.C. et al. 2019. C4 and crassulacean acid metabolism within a single leaf: deciphering key components behind a rare photosynthetic adaptation. New Phytologist 225, 1699–1714. DOI: https://doi.org/10.1111/nph.16265 

3. Guralnick, L.J. et al. 2008. Evolutionary physiology: the extent of C4 and CAM photosynthesis in the genera Anacampseros and Grahamia of the Portulacaceae. Journal of Experimental Botany 59(7), 1735–1742. DOI: https://doi.org/10.1093/jxb/ern081 

4. Hancock, L.P. et al. 2019. The evolution of CAM photosynthesis in Australian Calandrinia reveals lability in C3+CAM phenotypes and a possible constraint to the evolution of strong CAM. Journal of Experimental Botany 59(3), 517-534. DOI: https://doi.org/10.1093/icb/icz089 

5. Karger, D.K. et al. 2017. Climatologies at high resolution for the earth’s land surface areas. Scientific Data 4, 170122. DOI: https://doi.org/10.1038/sdata.2017.122

6. Landis, M.J. et al. 2020. Joint phylogenetic estimation of geographic movements and biome shifts during the global diversification of Viburnum. Systematic Biology 0(0), 1-20. DOI: https://doi.org/10.1093/sysbio/syaa027  

7. Majure, et al. 2019. Phylogenomics in Cactaceae: A case study using the chollas sensu lato (Cylindropuntieae, Opuntioideae) reveals a common pattern out of the Chihuahuan and Sonoran deserts. American Journal of Botany 106(10), 1-19. DOI: https://doi.org/10.1002/ajb2.1364 

8. Moore, et al. 2018. Targeted enrichment of large gene families for phylogenetic inference: phylogeny and molecular evolution of photosynthesis genes in the Portullugo clade (Caryophyllales). Systematic Biology 67(3), 367–383. DOI: https://doi.org/10.1093/sysbio/syx078 

9. Ocampo and Columbus. 2012. Molecular phylogenetics, historical biogeography, and chromosome number evolution of Portulaca (Portulacaceae). Molecular Phylogenetics and Evolution 63(1), 97-112. DOI: https://doi.org/10.1016/j.ympev.2011.12.017 
