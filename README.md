# Climate niche evolution in C4-CAM Portulaca and closely related C3-CAM lineages

## Phylogenetic Biology - Final Project

![Portullugo Intro](https://github.com/noraheaphy/finalproject/blob/master/figures/portullugo_intro_photos.png)

## Background

C4 and CAM are two photosynthetic pathways that have evolved from C3 photosynthesis hundreds of times independently over the last 30 million years (Figure 1). While biochemically similar, they are understood to represent two distinct ecological adaptations. The C4 pathway confers high photosynthetic rates, allowing C4 plants to live in hot temperatures and high light environments, while the CAM pathway confers high water use efficiency and drought tolerance, allowing CAM plants to live in arid regions (Edwards and Ogburn, 2012). There are a number of anatomical and ecological factors that would lead us to expect CAM and C4 to be mutually exclusive; characteristics favorable to evolving one pathway would seemingly disadvantage the other pathway. However, the purslane lineage (Portulaca) is able to operate both CAM and C4 cycles in a single leaf and is one of only two plants known to display this unique photosynthetic combination (Ferrari et al. 2019; Winter et al, 2020). Portulaca likely had a facultative CAM ancestor that subsequently evolved a C4 cycle at least three separate times while maintaining its CAM capabilities (Guralnick et al. 2008; Ocampo and Columbus, 2012).

![A Brief History of Photosynthesis](https://github.com/noraheaphy/finalproject/blob/master/figures/a_brief_history_Edwards2019.png)
*Figure 1. (left) Distribution of carbon concentrating mechanisms in the angiosperm phylogeny, showing multiple origins of CAM and C4 as well as phylogenetic clustering in certain lineages. (right) C4 and CAM biomolecular pathways.*

Here, I investigate how evolving C4-CAM photosynthesis affected the climate niche evolution of Portulaca in comparison to two closely related lineages: Calandrinia, a C3+CAM clade in Montiaceae, and Anacampserotaceae, Portulaca’s sister lineage, which contains facultative and constitutive CAM species but no C4 plants. Despite their different photosynthetic pathways, these plants are similar in many respects, including growth form, degree of succulence, herbaceousness, and annual growth cycle, making them a useful case study for examining the ecological selection pressures that drove the different lineages to evolve CAM, C3, C4, or some combination thereof (Hancock et al, 2018; Moore et al, 2018; Ocampo and Columbus, 2012). The climate niche comparison between Portulaca and Anacampserotaceae is global, in order to take into account the full ranges of these clades, while the comparison between Portulaca and Calandrinia is limited to Australia, where highly accurate locality data is available, in an attempt to balance the inevitable errors that accumulate in biodiversity databases like GBIF. Using environmental layers and species occurrence data, I infer the ecological consequences of evolving C4+CAM, C3+CAM, or full CAM photosynthesis from a shared ancestral C3+CAM phenotype (Figure 2). As outgroups, I also incorporate climatic, locality, and phylogenetic data for Cactaceae (strong CAM) and Talinum (C3-CAM), which form a clade with Anacampserotaceae and Portulacaceae (APCT). I hypothesize that evolving C4 shifted the ecological range of Portulaca into warmer and wetter environments, perhaps enabling the lineage to expand into a wider range of climatic conditions than its CAM and C3+CAM relatives.

![Ecological Consequences of Evolving C4-CAM](https://github.com/noraheaphy/finalproject/blob/master/figures/ecological_consequences_map.png)
*Figure 2. Phylogeny of Portullugo groups used in analysis, with Anacampserotaceae and Portulaca's shared C3-CAM ancestor marked in red. Global distributions of curated records downloaded from GBIF are shown for Calandrinia, Anacampserotaceae, and Portulaca.*

The delineation of species and clades within Portulaca and its sister groups are not well established. However, a phylogenetic perspective is critical to understanding the ecological implications of evolving C4-CAM photosynthesis as well as, more broadly, understanding how selection forces and genetic or biophysical constraints enable global convergent evolution of highly complex traits. Portulaca’s rare C4-CAM photosynthesis contradicts previous hypotheses that ecological and functional selection factors drive the evolution of CAM and C4 along predominantly separate trajectories, as does the presence of both CAM species and C4 species in many major clades. A more complete understanding of Portulaca as a model system for studying the evolution and ecological implications of CAM and C4 would further our knowledge of how organisms can evolve complex traits convergently and could eventually allow researchers to bioengineer both photosynthetic syndromes into a single crop, conferring drought tolerance and high productivity simultaneously and enabling agriculture in regions whose food security is threatened by climate change.

## Methods

### **1. Climate data acquisition**
I have downloaded all available specimen collection records for Portulaca, Anacampserotaceae, Cactaceae, Talinum, and Calandrinia from the [Global Biodiversity Information Facility (GBIF)](https://www.gbif.org/), supplemented with localities from the [Australian Virtual Herbarium](https://avh.chah.org.au/). I have thoroughly curated these records using the R package [Coordinate Cleaner](https://github.com/ropensci/CoordinateCleaner) to remove erroneous localities and verified taxonomic names to the fullest extent possible using the most plausible published phylogenies of these lineages. I have also excluded records from *P. oleracea, P. pilosa, T. paniculatum,* and *T. fruticosum*, as these are globally widespread weeds that would necessarily skew analyses of climatic niche. I downloaded environmental data in the form of global raster layers from [CHELSA](https://chelsa-climate.org/bioclim/). These 19 standard bioclimatic variables are shown in Table 1. I then extracted environmental data for each specimen locality in ArcGIS Pro. All analyses were conducted over a spatial resolution of 1 km<sup>2</sup> under the geodetic datum WGS84. A full dataset of localities, associated collection data, and extracted environmental variables is available in the data folder: [all_localities_extracted.csv](https://github.com/noraheaphy/finalproject/blob/master/data/all_localities_extracted_chelsa.csv). The scripts used to assemble, clean, and extract data are available in the scripts folder: [clean_gbif_data.R](https://github.com/noraheaphy/finalproject/blob/master/scripts/clean_gbif_data.R) and [env_extract.R](https://github.com/noraheaphy/finalproject/blob/master/scripts/env_extract.R)

| Variable name | Bioclimatic variable | Units |
|--------------|----------------------|-------|
| Bio1 | Annual Mean Temperature | &deg;C * 10 |
| Bio2 | Mean Diurnal Range | &deg;C * 10 |
| Bio3 | Isothermality | N/A |
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

### **2. Molecular data acquisition**
I had hoped to obtain the full data matrix of genes and taxa assembled by Ocampo and Columbus (2012), comprising 80 samples of Portulaca—59 species, 10 subspecies, 3 cultivars, and 3 outgroups from Cactaceae, Talinaceae, and Montiaceae. The matrix was assembled from nuclear ribosomal DNA loci (ITS, comprising ITS1, the 5.8S gene, and ITS2) and chloroplast DNA loci (protein-coding ndhF, trnT-psbD intergenic spacer, and ndhA intron. However, given the time constraints of the project and the unresponsiveness of the paper's authors, I opted instead to use a tree file provided by Ian Gilman in the Edwards Lab who had previously replicated Ocampo and Columbus's analysis. I obtained a full phylogeny for the Portullugo clade from the Edwards Lab (Figure 3) and subsetted this dataset to the Anacampserotaceae taxa. NEXUS files for each phylogeny can be found in the data folder of the repository: [Portulaca](https://github.com/noraheaphy/finalproject/blob/master/data/Ocampo_Portulaca.parts.treefile) and [Anacampserotaceae](https://github.com/noraheaphy/finalproject/blob/master/data/anacamps.treefile)

**Note:** The climate niche comparison between Anacampserotaceae and Portulaca is primarily phylogenetic, while the comparison between Calandrinia and Portulaca is primarily geographic. Therefore, Calandrinia is not currently included in the following phyolgenetic analyses.

#

![Portullugo Phylogeny from Moore et al. 2018](https://github.com/noraheaphy/finalproject/blob/master/figures/portullugo_phylo_Moore2018.png)
*Figure 3. Consensus tree generated for Portullugo by Moore, et al. 2018. Relationships between all major clades are well-supported (>95% bootstrap) in both coalescent (ASTRAL) and concatenated (RAxML) species trees.*

In R, I simplified these trees to only include taxa for which I had also collected climate data, resulting in a Portulaca phylogeny with 25 tips and an Anacampserotaceae phylogeny with 10 tips, containing representatives of all major lineages within the two groups (Figure 4).

![Taxa included in analysis](https://github.com/noraheaphy/finalproject/blob/master/figures/phylogenies_selected_taxa.png)
*Figure 4. Taxa drawn from Ocampo & Columbus 2012 (Portulaca) and Moore et al 2018 (Anacampserotaceae), for which I have both climate and phylogenetic data. The root of each tree is marked in red.*

### **3. Ancestral state reconstruction**
I calculated species level means for each environmental variable for all taxa in the phylogeny for which I had climate data, and then, using the R packages phytools, phylotools, ape, and ggtree, I mapped these climate character states onto the tips of the phylogeny, inferred the character states of internal nodes, and reconstructed the ancestral states for the base of the Anacampserotaceae clade and the base of the Portulaca clade. I used, first, a Brownian motion model to perform a Restricted Maximum Likelihood (REML) reconstruction of continuous character state evolution across each tree, and then I repeated the process using Phylogenetic Independent Contrasts (PIC). I compared the confidence intervals of the values reconstructed for each node under each method and plotted them against each other in order to evaluate the robustness of the reconstruction to the type of method used. I then plotted the reconstructed states on the phylogeny to compare the climate niche of the ancestral node of Portulaca and of Anacampserotaceae and to examine whether their divergence in climate space occurred near the root or closer to the present time.

Analysis files:

[Portulaca temperature ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/port_ancestral_reconstruct.Rmd)

[Portulaca precipitation ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/port_map_reconstruct.Rmd)

[Anacamposerotacaeae temperature ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/anacamps_ancestral_reconstruct.Rmd)

[Anacampserotaceae precipitation ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/anacamps_map_reconstruct.Rmd)

### **4. Phylogenetic signal**

I ran an analysis of phylogenetic signal for mean annual temperature and mean annual precipitation in Anacampserotaceae and Portulaca. Phylogenetic signal describes the tendency for related species to resemble each other more than species drawn at random from the same tree. The amount of "phylogenetic signal" in the trait data essentially tells us how much of this observed trait variation is simply due to time since divergence. The method below uses Blomberg's K to estimate phylogenetic signal. Values of K range from 0 to infinity, with an expected value of 1.0 under Brownian motion. Values of K < 1.0 describe data with less phylogenetic signal than expected, and values of K > 1.0 describe data with greater phylogenetic signal than expected due to chance.

Analysis files:

[Phylogenetic signal in Portulaca](https://github.com/noraheaphy/finalproject/blob/master/phylo_signal_port.Rmd)

[Phylogenetic signal in Anacampserotacaee](https://github.com/noraheaphy/finalproject/blob/master/phylo_signal_anacamps.Rmd)

## Results

### **1. Climate niche evolution: Portulaca and Anacampserotaceae**

A Wilcoxon ranked sum hypothesis test found that the difference in climate niche between Portulaca and Anacampserotaceae was statistically significant (p < 2.2 x 10<sup>-16</sup>), and all 19 bioclimatic variables had similarly low p-values when tested individually. Even after a Bonferroni correction was employed to account for the increase in Type I errors from multiple comparisons, all p-values were far below 0.05, indicating that there is considerable difference between the climate niches occupied by Portulaca and Anacampserotaceae worldwide. I selected mean annual temperature (MAT) and mean annual precipitation (MAP) as two particularly important species distribution predictors and plotted them against each other in order to visualize the overlap and differentiation between the two clades’ climate spaces. Portulaca occupies nearly the entire available global climate space, expanding beyond Anacampserotaceae’s climate space into warmer and wetter areas, while Anacampserotaceae is primary clustered in areas experiencing an average temperature between 12°C and 22°C and 0 to 1000 mm of rainfall annually (Figures 5, 6).

![Anacampserotaceae-Portulaca Global Distribution](https://github.com/noraheaphy/finalproject/blob/master/figures/port_anacamps_map_11-29-2020.jpg)
*Figure 5. Global distribution of curated localities for Portulaca (blue) and Anacampserotaceae (red). Note that Anacampserotaceae has a much more restricted geographic distribution than Portulaca.*

![Anacampserotaceae-Portulaca Climate Space Biplots](https://github.com/noraheaphy/finalproject/blob/master/figures/ana_port_biplots.png)
*Figure 6. Mean annual temperature (MAT) vs. mean annual precipitation (MAP) for Anacampserotaceae (a) and Portulaca (b) with respect to each other's climate niche space. Portulaca occupies almost the entire available niche space including Anacampserotaceae's niche space, but also extends beyond Anacampserotaceae into a warmer and wetter zone.*

This difference in climate niche space, while significant, could hypothetically be attributed to the difference in size of the two groups’ geographic ranges. Even with P. oleracea and P. pilosa removed from the analysis, Portulaca is widely distributed across Australia, Africa, and North and South America, while Anacampserotaceae is confined to four clusters in South Africa, Australia, Argentina, and Mexico. To investigate this possible confounding factor, I repeated the above analysis with only Portulaca records located within 500 km<sup>2</sup> of an Anacampserotaceae locality. The statistically significant difference in niche space generated by the Wilcoxon test persisted with p < 2.2 x 10<sup>-16</sup>, and individual climate variables generated p-values of less than 0.05 with the exception of the precipitation of the driest quarter and the precipitation of the coldest quarter, which were not statistically significant. Precipitation of the driest month and temperature seasonality were not statistically significant after the Bonferroni correction was applied, but all other bioclimatic variables remained significant. When plotting MAT vs. MAP for the buffered dataset, the overlap between the two groups’ climate spaces is larger, but Portulaca still occupies a region of the total available climate space characterized by higher temperatures and higher precipitation from which Anacampserotaceae is entirely absent (Figures 7, 8). In both the buffered and unbuffered biplots of Portulaca’s climate space, the set of points occupying temperatures between 0°C and 10°C correspond to the species P. perennis, which has only 11 localities represented in this dataset, all of which are distributed in the mountains of Argentina and likely at very high altitudes.

![Anacampserotaceae-Portulaca With Buffer Map](https://github.com/noraheaphy/finalproject/blob/master/figures/port_ana_buffer_exluded.jpg)
*Figure 7. Portulaca points included in buffered analysis (blue) represent only Portulaca localities within 500 km of an Anacampserotaceae locality. Portulaca localities located outside of Anacampserotaceae's typical range are depicted in yellow and excluded from this analysis. This is an attempt to determine whether the differences in climate niche space between Anacampserotaceae and Portulaca observed above are only due to Portulaca's wider geographic range.*

![Anacampserotaceae-Portulaca With Buffer Biplots](https://github.com/noraheaphy/finalproject/blob/master/figures/port_ana_buffer_biplots.png)
*Figure 8. Mean annual temperature (MAT) vs. mean annual precipitation (MAP) for Anacampserotaceae (a) and Portulaca (b) with respect to each other's climate niche space. Even when restricting the analysis to Portulaca points that roughly co-occur with Anacampserotaceae points, Portulaca is clearly moving into a new climate niche characterized by higher temperatures and precipitation.*

### **2. Climate niche evolution: Portulaca and Calandrinia**

As with Portulaca and Anacampserotaceae, the Wilcoxon ranked sum test found that Portulaca and Calandrinia occupy significantly different climate niches within the Australian continent (p < 2.2 x 10<sup>-16</sup>), and all individually tested bioclimatic variables remained significant even after accounting for errors generated by multiple comparisons. Biplots of MAT vs. MAP for Calandrinia and Portulaca show that Portulaca’s climate space entirely overlaps with that of Calandrinia, but occupies the high temperature, high precipitation region of the climate space (Figures 9, 10). Unlike the global Anacampserotaceae-Portulaca biplots, where Portulaca occupies virtually all of the global climate space suitable for terrestrial vegetation, Calandrinia’s MAT vs. MAP plot shows a curiously curved distribution, with moderate precipitation at lower temperatures (10-17°C) and high precipitation at higher temperatures (25-29°C), but with very little precipitation in areas experiencing moderate temperatures. A null climate space of 10,000 randomly plotted points within Australia confirms that this curved shape is representative of the available climate space of the entire continent (Figure 11).

![Calandrinia-Portulaca Australian Distribution](https://github.com/noraheaphy/finalproject/blob/master/figures/calandrinia_port_map_11-29-2020.jpg)
*Figure 9. Australian distribution of curated localities for Portulaca (blue) and Calandrinia (red). While the distributions of the two groups overlap, Portulaca is mostly confined to the northern part of the continent, the warmer and wetter part of the total climate space of Australia.*

![Calandrinia-Portulaca Climate Space Biplots](https://github.com/noraheaphy/finalproject/blob/master/figures/cal_port_aus_biplots.png)
*Figure 10. Mean annual temperature (MAT) vs. mean annual precipitation (MAP) for Calandrinia (a) and Portulaca (b) with respect to each other's climate niche space in Australia. The curved shape of the niche space is representative of the shape of the total available climate space in Australia. Portulaca's niche space entirely overlaps with that of Calandrinia, but represents the warmer and wetter part of Calandrinia's total niche.*

![Australia null climate](https://github.com/noraheaphy/finalproject/blob/master/figures/australia_null_climate_biplot.jpeg)

*Figure 11. Mean annual temperature (MAT) vs. mean annual precipitation (MAP) for 10,000 randomly sampled points located in Australia. The curved distribution matches the distribution of climate zones across the continent, with a large central desert and savannah surrounded by tropical forest on the northern coast and a more temperate, mediterranean region to the south.*

 A few individual bioclimatic variables stand out as particularly notable in this comparison (Figure 12). Calandrinia’s climate niche for mean temperature of the wettest quarter is bimodal, with some localities experiencing low temperatures in the wettest quarter, some experiencing high temperatures, but no localities experiencing moderate temperatures. Portulaca solely occupies the portion of Calandrinia’s climate space experiencing very high mean temperatures during the wettest quarter, suggesting that Portulaca is specializing in the tropical, monsoonal climate space of its C3-CAM relative. Portulaca, on average, experiences greater precipitation seasonality than Calandrinia, and Portulaca clearly inhabits a warm season precipitation zone, while Calandrinia inhabits a cold season precipitation zone.

 ![Monsoonal climate specialization](https://github.com/noraheaphy/finalproject/blob/master/figures/cal_port_monsoon_plots.png)
 *Figure 12. Comparisons between Australian Calandrinia and Portulaca for a few notable bioclimatic variables. a) Portulaca solely occupies the more tropical monsoonal climate space of Calandrinia characterized by higher temperatures in the wettest quarter of the year. b) Portulaca occupies the subset of Calandrinia’s climate space that experiences greater precipitation seasonality. c) Portulaca lives under a warm season precipitation regime, while d) Calandrinia lives under a cold season precipitation regime.*

### **3. Climate niche evolution: Outgroups**

To ensure a more accurate phylogenetic comparison, I incorporated global climate and locality data for two outgroups for Anacampserotaceae and Portulaca—Talinum and Cactaceae which together form the APCT clade in Portullugo. Talinum, which includes primarily facultative CAM species, and Cactaceae, which includes some facultative CAM species and a high concentration of constitutive “strong CAM” species, are more similar in their climate space to Anacampserotaceae than to Portulaca (Figure 13). Although the distinction is not quite so clear, Portulaca does seem to be moving into a warmer, wetter climate niche space characterized by more seasonal precipitation, in comparison to any other member of the APCT clade.

![Outgroups Climate Niche](https://github.com/noraheaphy/finalproject/blob/master/figures/outgroups_climate.png)
*Figure 13. When including Cactaceae and Talinum as outgroups for Anacampserotaceae and Portulaca, forming the APCT clade, these were the four bioclimatic variables that showed the most differentiation of Portulaca from the rest of the clade. Portulaca is moving into a warmer, wetter, and more seasonal climate niche space than that which is occupied by any of its closest relatives.*

### **4. Ancestral state reconstruction**

Restricted maximum likelihood (REML) and phylogenetic independent contrasts (PIC) both reconstructed the ancestral temperature and precipitation niche of Portulaca to be higher than the ancestral niche of Anacampserotaceae (Figure 14). Under REML, Portulaca’s ancestor is reconstructed to have a mean annual temperature of 22.9°C, while Anacampserotaceae’s ancestor is reconstructed to have a mean annual temperature of 17°C. Under PIC, Portulaca’s ancestral value is 21.5°C, and Anacampserotaceae’s is 17.2°C. Estimates of node character values are well outside the other group’s 95% confidence interval, but estimates for PIC vs. REML for the same species are within each other’s confidence interval. The reconstructed values for precipitation niche similarly diverge across the two groups but are similar for each reconstruction method. Portulaca’s ancestor is estimated to have a mean annual precipitation of 668 mm/year under REML and 626 mm/year under PIC, while Anacampserotaceae’s ancestor has a mean annual precipitation of 374 mm/year under both REML and PIC.

### REML MAT ancestral reconstruction

![REML MAT ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/figures/reml_mat_final.png)
*Figure 14a. Restricted maximum likelihood (REML) reconstructions of the ancestral temperature niche of Portulaca (left) and Anacampserotaceae (right). Tip nodes represent averages of all localities for each species. Note that the scales are different in order to show a meaningful distribution of colors. Portulaca’s ancestral niche is reconstructed to be 22.9°C, 95% CI [1.99-43.8], while Anacampserotaceae’s ancestral niche is reconstructed as 17°C, 95% CI [16.6-18.0].*

### PIC MAT ancestral reconstruction

![PIC MAT ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/figures/pic_mat_final.png)
*Figure 14b. Phylogenetic independent contrasts (PIC) reconstructions of the ancestral temperature niche of Portulaca (left) and Anacampserotaceae (right). Tip nodes represent averages of all localities for each species. Note that the scales are different in order to show a meaningful distribution of colors. Portulaca’s ancestral niche is reconstructed to be 21.5°C, 95% CI [20.0-23.1], while Anacampserotaceae’s ancestral niche is reconstructed as 17.2°C, 95% CI [16.3-18.3].*

### REML MAP ancestral reconstruction

![REML MAP ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/figures/reml_map_final.png)
*Figure 14c. Restricted maximum likelihood (REML) reconstructions of the ancestral precipitation niche of Portulaca (left) and Anacampserotaceae (right). Tip nodes represent averages of all localities for each species. Note that the scales are different in order to show a meaningful distribution of colors. Portulaca’s ancestral niche is reconstructed to be 668 mm/year, 95% CI [647-689], while Anacampserotaceae’s ancestral niche is reconstructed as 374 mm/year, 95% CI [343-406].*

### PIC MAP ancestral reconstruction

![PIC MAP ancestral reconstruction](https://github.com/noraheaphy/finalproject/blob/master/figures/pic_map_final.png)
*Figure 14d. Phylogenetic independent contrasts (PIC) reconstructions of the ancestral precipitation niche of Portulaca (left) and Anacampserotaceae (right). Tip nodes represent averages of all localities for each species. Note that the scales are different in order to show a meaningful distribution of colors. Portulaca’s ancestral niche is reconstructed to be 626 mm/year, 95% CI [624-627], while Anacampserotaceae’s ancestral niche is reconstructed as 374 mm/year, 95% CI [372-376].*

Examining the distribution of character values at the tips of each tree, we see that temperature is more clustered in the phylogeny than precipitation. With the exception of a particularly cold clade that includes the Chilean outlier P. perennis, every tip in Portulaca has a higher temperature than any tip in Anacampserotaceae, though there is more overlap between the groups for precipitation niche. The distribution of tips along the tree indicates that their doesn’t seem to be any particularly warm or wet Portulaca clade that is pulling up the average of the entire group. A comparison of the performance of the REML and PIC ancestral reconstruction methods shows that with a few exceptions, both methodologies reconstruct very similar values for the same node (Figure 15). Most importantly, the ancestral nodes—49 for Portulaca and 11 for Anacampserotaceae—are very close to the line and therefore do not differ greatly between REML and PIC reconstructions.

### Comparison of ancestral reconstruction methods

![Compare ancestral reconstruction methods](https://github.com/noraheaphy/finalproject/blob/master/figures/compare_mat_pic_reml.png)
*Figure 15. Comparison between the node character values generated by REML and PIC. Points deviate from the center line in accordance with how different the mean annual temperature values derived by each method are from each other. All points are within acceptable confidence intervals, and the conclusions appear to be robust to the type of ancestral reconstruction method used.*

The analysis of phylogenetic signal for both groups and both climate variables produced K values less than 1, indicating that the phylogenetic signal is less than would be expected under Brownian motion (Figure 16). The phylogenetic signal of Portulaca is closer to 0, while that of Anacampserotaceae is quite close to 1. This suggests that the variation in temperature and precipitation across the Portulaca phylogeny is not simply due to the time since divergence and that Portulaca has more phylogenetic clustering of climate niche than Anacampserotaceae, a phenomenon that could be interpreted as intra-clade niche conservatism vs. divergence. However, I am hesistant to read too much into this particular analysis given the low number of taxa in these trees and the ambiguity of the results.

### Phylogenetic signal

![Phylogenetic signal](https://github.com/noraheaphy/finalproject/blob/master/figures/phylogenetic_signal.png)
*Figure 16. Phylogenetic signal of mean annual temperature (MAT) and mean annual precipitation (MAP) in Anacampserotaceae and Portulaca estimate using Blomberg's K, which takes values ranging from 0 to infinity, with an expected value of 1 under Brownian motion.*

## Discussion

This study provides the first comprehensive investigation of climate niche differentiation and evolution between C4-CAM and C3-CAM lineages. As hypothesized, Portulaca specializes in the more tropical, monsoonal area of the total climate niche of its C3-CAM relative Calandrinia. Additionally, Portulaca has expanded its global niche beyond its C3-CAM sister lineage Anacampserotaceae into warmer and wetter regions. This niche expansion is robust even to constraints imposed on the dataset that limited Portulaca’s range to roughly the same geographic areas as Anacampserotaceae, strongly suggesting that Portulaca’s novel evolution of C4-CAM photosynthesis allowed it to inhabit a wider range of climatic conditions than its C3-CAM relatives, experiencing higher temperatures, more precipitation, and greater precipitation seasonality concentrated in the warm season. While Portulaca’s Australian niche space and geographic range entirely overlaps with that of Calandrinia, Portulaca has likely colonized Australia three separate times, while Calandrinia has only one origin on the continent (Hancock et al, 2018; Ocampo and Columbus, 2012). This would indicate that Portulaca is not found only in the northern half of the continent because it hasn’t yet had enough time to spread south, but because of an actual climatic limitation on its distribution.

The ancestral reconstructions of temperature niche and precipitation niche suggest that Portulaca’s movement into warmer and wetter spaces occurred near the base of the clade, when it diverged from Anacampserotaceae and that the clade containing P. perennis subsequently diversified into a colder environment than its ancestor. However, ancestral reconstructions necessarily incorporate untested assumptions about edge lengths into their calculations, and therefore one data point for the basal node of Portulaca and Anacampserotaceae is not sufficient to draw conclusions here, as it could be impacted by inaccuracies in the rate of evolution along certain branches. To verify that there is a statistically significant difference between the ancestral climatic niche of Portulaca and that of Anacampserotaceae, future work should incorporate a sensitivity analysis of the impact of edge length on the ancestral character values. By scaling edge lengths in accordance with a random noise element, a distribution of trees could be generated, sharing the same topology but different edge lengths. From this distribution of ancestral character values, a difference of means hypothesis test could be performed to verify that the climate niche of Portulaca’s ancestor was significantly warmer and wetter than that of Anacampserotaceae’s ancestor and that this difference is relatively robust to errors in estimated rates of evolution and perhaps even to minor variations in tree topology.

No evidence was found to suggest that one particular clade within Portulaca has moved into an extremely warm and wet temperature niche, unduly skewing the average. Noting that Portulaca, Anacampserotaceae, and Calandrinia share many physiological and ecological similarities despite their different photosynthetic pathways, this points to two possible explanations: 1) Portulaca’s unique evolution of C4-CAM within Portullugo enabled it to expand its climate range, persisting in warmer and wetter environments that remained inhospitable to its C3-CAM ancestors and sister lineages, or 2) Portulaca’s pre-existing range in warmer and wetter climates drove it to evolve the C4-CAM phenotype, while its C3-CAM relatives in more moderate environments did not face similar selection pressures. Given the apparent rarity of the C4-CAM phenotype in the phylogenetic tree, the first explanation seems considerably more likely, as plenty of plant clades inhabiting environments that are similar to or even more warm and wet than that of Portulaca have not evolved C4-CAM, even though they’ve had a far longer time to do so. A reasonable next step to test this hypothesis would be to conduct a wider phylogenetic analysis of climate niche evolution in the APCT clade. This would require testing several methods of grafting the Portulaca and Anacampserotaceae phylogenies, which were inferred using different methods and regions of the genome, making them difficult to combine in a way that produces meaningful edge lengths. Combined phylogenies of this sort represents a major challenge to the development of large-scale phylogenomics and phylodiversity analyses, and possible avenues forward may include: 1) estimating edge lengths for each phylogeny independently, grafting the trees together based on the assumption that they form a clade, time calibrating branches accordingly, and testing time calibrations by adding jitter into the sensitivity analysis; 2) concatenating data for varying genes into a single large matrix with many gaps, and inferring the phylogeny based on this matrix; and 3) choosing the most taxon-restricted dataset with the best character sampling, inferring a constraint tree based on that dataset, and then restricting the Maximum Likelihood search for the overall tree to possibilities that are compatible with the constraint tree (Landis et al. 2020).

Once a joint tree of Anacampserotaceae and Portulaca has been successfully inferred, adding Cactaceae and Talinum into the analysis should provide more confidence in the proposed conclusion that Portulaca’s C4-CAM innovation led to an increase in temperature and precipitation niche evolution at the base of the clade, causing the lineage to diverge from the rest of the APCT clade and diversify into warmer and wetter zones. A number of contradictory Cactaceae phylogenies are in use, but the whole-plastome tree generated by Majure, et al. (2019) is a plausible candidate for an outgroup analysis. Obtaining a phylogeny of intra-clade relationships for Talinum may be hampered by undersampling and a handful of widespread weedy taxa, but regardless, the relationships between these two outgroups and Portulaca and Anacamsperotaceae are well-supported, which is the most important factor for the viability of the climate niche evolution analysis (Moore et al, 2018). Another avenue of further investigation would be to replicate this study in Trianthema, the second lineage recently confirmed to be able to perform both C4 and CAM photosynthesis, and a few of its relatives in Aizoaceae that do C3, C3-CAM, CAM, or C4. If Trianthema also occupies a higher temperature, higher precipitation niche than its C3-CAM and strong CAM relatives, this would lend further credibility to the association between photosynthesis phenotype and climate niche presented here.

Untangling the complicated relationships between the global convergent evolution of the CAM and C4 pathways, the broad variation of facultative CAM phenotypes, and the present distribution of plant lineages in a rapidly changing global biosphere is a lengthy process, but one that has considerable implications for both our ability to provide sufficient food sources in the near and long term and our understanding of the fundamental mechanisms of evolution. The rapid niche expansion of Portulaca in comparison to Anacampserotaceae provides a counterexample to the theory of phylogenetic niche conservatism—the paradigm under which conserved traits limit the distribution of organisms to particular phylogenetically clustered climate spaces (Ogburn and Edwards, 2015). We know that rapid niche diversification and adaptation to novel climates is possible under certain circumstances, and identifying the particular physiological, genetic, and situational factors that enable one lineage to evolve its niche rapidly while another evolves within a narrow set of climatic conditions is of increasing importance as many organisms face massive environmental upheaval in the form of climate change and land use change. CAM and C4 photosynthesis represent one of the most important adaptations in the evolutionary history of land plants, and Portulaca still has much to teach us about evolutionary responses to ecological change and their subsequent ecological consequences.

## Reflection

The most challenging part of implementing these analyses was honing my analyses and determining what was reasonable to take on given the scope and timeline of the final project. I was lucky enough to have spent the better part of a year gathering and cleaning this dataset, so that part was relatively easy, but at the beginning of the semester, I had very little idea of what possible analytical routes were available to me. If I did these analyses again, I would start with a clearer picture of exactly what steps I would take towards my final results and how I would carry them out.

## References

1. Edwards, E.J. and Ogburn, R.M. 2012. Angiosperm responses to a low-CO2 world: CAM and C4 photosynthesis as parallel evolutionary trajectories. International Journal of Plant Sciences 173(6), 724-733. DOI: https://doi.org/10.1086/666098 

2. Edwards, E.J. 2019. Evolutionary trajectories, accessibility and other metaphors: the case of C4 and CAM photosynthesis. New Phytologist 223: 1742-1755. DOI: https://doi.org/10.1111/nph.15851 

3. Ferrari, R.C. et al. 2019. C4 and crassulacean acid metabolism within a single leaf: deciphering key components behind a rare photosynthetic adaptation. New Phytologist 225, 1699–1714. DOI: https://doi.org/10.1111/nph.16265

4. Guralnick, L.J. et al. 2008. Evolutionary physiology: the extent of C4 and CAM photosynthesis in the genera Anacampseros and Grahamia of the Portulacaceae. Journal of Experimental Botany 59(7), 1735–1742. DOI: https://doi.org/10.1093/jxb/ern081

5. Hancock, L.P. et al. 2019. The evolution of CAM photosynthesis in Australian Calandrinia reveals lability in C3+CAM phenotypes and a possible constraint to the evolution of strong CAM. Journal of Experimental Botany 59(3), 517-534. DOI: https://doi.org/10.1093/icb/icz089

6. Karger, D.K. et al. 2017. Climatologies at high resolution for the earth’s land surface areas. Scientific Data 4, 170122. DOI: https://doi.org/10.1038/sdata.2017.122

7. Landis, M.J. et al. 2020. Joint phylogenetic estimation of geographic movements and biome shifts during the global diversification of Viburnum. Systematic Biology 0(0), 1-20. DOI: https://doi.org/10.1093/sysbio/syaa027  

8. Majure, et al. 2019. Phylogenomics in Cactaceae: A case study using the chollas sensu lato (Cylindropuntieae, Opuntioideae) reveals a common pattern out of the Chihuahuan and Sonoran deserts. American Journal of Botany 106(10), 1-19. DOI: https://doi.org/10.1002/ajb2.1364

9. Moore, et al. 2018. Targeted enrichment of large gene families for phylogenetic inference: phylogeny and molecular evolution of photosynthesis genes in the Portullugo clade (Caryophyllales). Systematic Biology 67(3), 367–383. DOI: https://doi.org/10.1093/sysbio/syx078

10. Ocampo and Columbus. 2012. Molecular phylogenetics, historical biogeography, and chromosome number evolution of Portulaca (Portulacaceae). Molecular Phylogenetics and Evolution 63(1), 97-112. DOI: https://doi.org/10.1016/j.ympev.2011.12.017

10. Winter, et al. 2020. Does the C4 plant Trianthema portulacastrum (Aizoaceae) exhibit weakly expressed crassulacean acid metabolism (CAM)? Functional Plant Biology. DOI: https://doi.org/10.1071/FP20247 
