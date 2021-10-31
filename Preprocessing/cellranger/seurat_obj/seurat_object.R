#!/usr/bin/env Rscript
library(Seurat)
library(tidyverse)

args_c = commandArgs(trailingOnly = TRUE)

samples= read_delim(args_c[2], delim="\n",col_names=FALSE) %>% pull(X1)

path_to_samples = args_c[1]

output_path = args_c[3]

for (i in 1:length(samples)) {
    data = Read10X(data.dir = paste0(path_to_samples,"/sample_",samples[i],"/outs/filtered_feature_bc_matrix"))

    seurat_obj = CreateSeuratObject(counts = data, min.cells = 3, min.features  = 200, 
                                  project = samples[i], assay = "RNA")
                         
    saveRDS(seurat_obj, file = sprintf("%s/sample_%s_cr.rds", output_path,samples[i]))
}