# Phylogenetic Biology - Final Project

## Guidelines - you can delete this section before submission

This repository is a stub for your final project. Fork it, develop your project, and submit it as a pull request. Edit/ delete the text in this readme as needed.

Some guidelines and tips:

- Use the stubs below to write up your final project. Alternatively, if you would like the writeup to be an executable document (with [knitr](http://yihui.name/knitr/), [jupytr](http://jupyter.org/), or other tools), you can create it as a separate file and put a link to it here in the readme.

- For information on formatting text files with markdown, see https://guides.github.com/features/mastering-markdown/ . You can use markdown to include images in this document by linking to files in the repository, eg `![GitHub Logo](/images/logo.png)`.

- The project must be entirely reproducible. In addition to the results, the repository must include all the data (or links to data) and code needed to reproduce the results.

- If you are working with unpublished data that you would prefer not to publicly share at this time, please contact me to discuss options. In most cases, the data can be anonymized in a way that putting them in a public repo does not compromise your other goals.

- Paste references (including urls) into the reference section, and cite them with the general format (Smith at al. 2003).

- Commit and push often as you work.

OK, here we go.

# Climate niche evolution in C4-CAM Portulaca and closely related C3-CAM lineages

## Background

C4 and CAM are two photosynthetic pathways that have evolved from C3 photosynthesis hundreds of times independently over the last 30 million years. While biochemically similar, they are understood to represent two distinct ecological adaptations. The C4 pathway confers high photosynthetic rates, allowing C4 plants to live in hot temperatures and high light environments, while the CAM pathway confers high water use efficiency and drought tolerance, allowing CAM plants to live in arid regions (Edwards and Ogburn, 2012). There are a number of anatomical and ecological reasons that would lead us to expect CAM and C4 to be mutually exclusive; characteristics favorable to evolving one pathway would seemingly disadvantage the other pathway. However, the purslane lineage (Portulaca) is able to operate both CAM and C4 cycles in a single leaf and is the only plant known to display this unique photosynthetic combination (Ferrari et al. 2019). Portulaca likely had a facultative CAM ancestor that subsequently evolved a C4 cycle at least three separate times while maintaining its CAM capabilities (Guralnick et al. 2008). 

For this project, I will investigate how evolving C4-CAM photosynthesis affected the climate niche evolution of Portulaca in comparison to two closely related lineages: Calandrinia, a C3+CAM clade in Montiaceae, and Anacampserotaceae, Portulaca’s sister lineage, which contains facultative and constitutive CAM species but no C4 plants. Despite their different photosynthetic pathways, these plants are similar in many respects, including growth form, degree of succulence, herbaceousness, and annual growth cycle, making them a useful case study for examining the ecological selection pressures that drove the different lineages to evolve CAM, C3, C4, or some combination thereof (Ocampo and Columbus, 2012). The climate niche comparison between Portulaca and Anacampserotaceae will be global, in order to take into account the full ranges of these clades, while the comparison between Portulaca and Calandrinia will be limited to Australia, where highly accurate locality data is available, in an attempt to balance the inevitable errors that accumulate in biodiversity databases like GBIF. Using environmental layers and species occurrence data, I will infer the ecological consequences of evolving C4+CAM, C3+CAM, or full CAM photosynthesis from a shared ancestral C3+CAM phenotype. As outgroups, I will also incorporate climatic, locality, and phylogenetic data for Cactaceae (strong CAM) and Talinum (C3-CAM), which form a clade with Anacampserotaceae and Portulacaceae (APCT). I hypothesize that evolving C4 shifted the ecological range of Portulaca into warmer and wetter environments, perhaps enabling the lineage to expand into a wider range of climatic conditions than its CAM and C3+CAM relatives. 

The evolutionary relationships between and within Portulaca and related clades are not well established. However, a phylogenetic perspective is critical to understanding the ecological implications of evolving C4-CAM photosynthesis as well as more broadly exploring the question of what selection forces drive global convergent evolution of highly complex traits. Portulaca’s unique C4-CAM photosynthesis contradicts previous hypotheses that ecological and functional selection factors drive the evolution of CAM and C4 along predominantly separate trajectories, as does the presence of both CAM species and C4 species in many major clades. A more complete understanding of Portulaca as a model system for studying the evolution and ecological implications of CAM and C4 would further our knowledge of how organisms can evolve complex traits convergently and could eventually allow researchers to bioengineer both photosynthetic syndromes into a single crop, conferring drought tolerance and high productivity simultaneously and enabling agriculture in regions whose food security is threatened by climate change.

## Methods

I have downloaded all available specimen collection records for Portulaca, Anacampserotaceae, Cactaceae, Talinum, and Calandrinia from the Global Biodiversity Information Facility (GBIF), supplemented with localities from other databases such as iDigBio and the Australian Virtual Herbarium. I have thoroughly curated these records using the R package Coordinate Cleaner to remove erroneous localities, and I will verify taxonomic names to the fullest extent possible using the most plausible published phylogeny of these lineages. I will download environmental data in the form of global raster layers from CHELSA and the Australian Bureau of Meteorology, supplementing the standard 19 bioclimatic variables with data on potential evapotranspiration and aridity index. I will then extract environmental data for each specimen locality in ArcGIS Pro. All analyses will be conducted over a spatial resolution of 1 km2 under the geodetic datum WGS84.

I will use an Anacampserotaceae phylogeny constructed via transcription enrichment and provided by the Edwards Lab (Moore, et al. 2017). The best available published phylogenies for Portulaca and Calandrinia are from Ocampo and Columbus (2012) and Hancock, et al. (2019) respectively. A number of contradictory Cactaceae phylogenies are in use, but the whole-plastome tree generated by Majure, et al. (2019) is a plausible candidate. Obtaining a phylogeny of intra-clade relationships for Talinum may be hampered by undersampling and a handful of widespread weedy taxa, but regardless, the relationships between these two outgroups and Portulaca and Anacamsperotaceae are well-supported, which is the most important factor for the viability of the climate niche evolution analysis. 

After using ANOVA and phylogenetic PCA to examine climate niche evolution across these published phylogenies, I will conduct a sensitivity analysis, introducing elements of randomization and eliminating taxa from the phylogeny to test the robustness of the results to possible errors and noise. A major obstacle to using phylogenetic comparative methods across the APCT clade is that the phylogenies described above were constructed using different forms of data (transcription enrichment, whole-plastome sequencing, PCR, etc). Topologies can be combined relatively easily, but generating meaningful edge lengths is more complicated. I will investigate the feasibility of several methods of incorporating heterogeneous data into my analyses using RevBayes:
  1. Estimate edge lengths for each phylogeny independently, graft the trees together based on assumption that they form a clade, time calibrate branches accordingly, and test time calibrations by adding jitter in the sensitivity analysis.
  2. Concatenate data for varying genes into a single large matrix with many gaps and infer phylogeny based on this matrix (Landis et al. 2020).
  3. Choose the most taxon-restricted dataset with the best character sampling, infer a constraint tree based on that dataset, restrict Maximum Likelihood search for overall tree to possibilities compatible with the constraint tree (Landis et al. 2020).

## Methods

The tools I used were... See analysis files at (links to analysis files).

## Results

The tree in Figure 1...

## Discussion

These results indicate...

The biggest difficulty in implementing these analyses was...

If I did these analyses again, I would...

## References

Edwards and Ogburn. 2012. Angiosperm responses to a low-CO2 world: CAM and C4 photosynthesis as parallel evolutionary trajectories. International Journal of Plant Sciences. 

Ferrari, et al. 2019. C4 and crassulacean acid metabolism within a single leaf: deciphering key components behind a rare photosynthetic adaptation. New Phytologist.

Guralnick, et al. 2008. Evolutionary physiology: the extent of C4 and CAM photosynthesis in the genera Anacampseros and Grahamia of the Portulacaceae. Journal of Experimental Botany.

Hancock, et al. 2019. The evolution of CAM photosynthesis in Australian Calandrinia reveals lability in C3+CAM phenotypes and a possible constraint to the evolution of strong CAM. Journal of Experimental Botany.

Landis, et al. 2020. Joint phylogenetic estimation of geographic movements and biome shifts during the global diversification of Viburnum. Systematic Biology. 

Majure, et al. 2019. Phylogenomics in Cactaceae: A case study using the chollas sensu lato (Cylindropuntieae, Opuntioideae) reveals a common pattern out of the Chihuahuan and Sonoran deserts. American Journal of Botany.

Moore, et al. 2017. Targeted enrichment of large gene families for phylogenetic inference: phylogeny and molecular evolution of photosynthesis genes in the Portullugo clade (Caryophyllales). Systematic Biology. 

Ocampo and Columbus. 2012. Molecular phylogenetics, historical biogeography, and chromosome number evolution of Portulaca (Portulacaceae). Molecular Phylogenetics and Evolution.
