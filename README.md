## Single cell atlas of neural development in the murine olfactory bulb  



## Introduction   

In order to investigate the development of the olfactory bulb during the critical period, here we perform an analysis of scRNA-seq data from 10 mouse olfactory bulbs each at different developmental time points (E14, E18, P0, P3, P5, P7, P10, P14, P21, and Adult). These tissue samples were dissociated and sequenced on the 10x Genomics' single-cell RNA-seq platform. Our analysis focuses on the cells identified as interneurons through differential expression analysis.

## Methods   

### Preprocessing  

We performed 10x Genomics Cell Ranger 6.1.1 and kallisto \| bustools preprocessing to compare the resulting count matrices using the most recent ensembl release (104) of the mus musculus genome GRCm39. We then filtered the empty droplets from the kb count ouput and saved the outputs from both pipelines as RDS R objects for downstream comparison in Seurat. For additional documentation of the CellRanger or kallisto \| bustools preprocessing steps click the following links:   
<a href="https://natalie-23-gill.github.io/scRNA_Murine_Olfactory_Bulb/Preprocessing/cellranger/cellranger.html">CellRanger</a> <a href="https://natalie-23-gill.github.io/scRNA_Murine_Olfactory_Bulb/Preprocessing/kallisto_bustools/kallisto_bustools.html">kallisto \| bustools</a>.

#### Created: 10/07/2021

#### PI: Dr. Ron Yu CRY@stowers.org    

#### Mentors: Annie Wang AWang@stowers.org, Max Hills MHills@stowers.org    

#### Contributors: Laura Paez, Natalie Elphick and Christina Zakarian   

## References   

1.Zheng, G. X. Y. et al. Massively parallel digital transcriptional profiling of single cells. Nat Commun 8, 14049 (2017).   
2.Bray, N. L., Pimentel, H., Melsted, P. & Pachter, L. Near-optimal probabilistic RNA-seq quantification. Nat Biotechnol 34, 525–527 (2016).   
3.Melsted, P. et al. Modular, efficient and constant-memory single-cell RNA-seq preprocessing. Nat Biotechnol 39, 813–818 (2021).   


