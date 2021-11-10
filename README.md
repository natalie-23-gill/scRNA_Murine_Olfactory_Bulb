# Single cell atlas of neural development in the murine olfactory system  

#### Created: 10/07/2021

</br>

#### PI: Dr. Ron Yu CRY@stowers.org    

#### Mentors: Annie Wang AWang@stowers.org, Max Hills MHills@stowers.org    


</br>


#### Contributors: Laura Paez, Natalie Elphick and Christina Zakarian   

</br>


## Project goals   

1. Learn how to map reads and extract expression data for individual cells.
2. Cluster cells according to their gene expression patterns.
3. Use marker genes to identify cell types and clusters.
4. Use statistical analyses to identify cells that are enriched in specific cell types.
5. Use trajectory analysis to determine the lineage connections of the cells.   



### 1. Preprocessing  

We performed cellranger and kallisto | bustools preprocessing to compare the resulting count matrices using the most recent ensembl release (104) of the mus musculus genome GRCm39. We then filtered the empty droplets from the kb count ouput and saved the outputs from both pipelines as RDS R objects for downstream comparison in Seurat. Additional documentation can be found in the cellranger and kallisto_bustools subdirectories under ./Preprocessing. 

