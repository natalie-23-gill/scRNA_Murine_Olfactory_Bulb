#!/usr/bin/env Rscript
library(Seurat)
library(DropletUtils)
library(BUSpaRse)
library(tidyverse)

args_c = commandArgs(trailingOnly = TRUE)

# Set working directory to argument path
setwd(args_c[1])

# Read in sample list from arguments 
samples_list = read_delim(args_c[2], delim="\n",col_names=FALSE) %>% pull(X1)

# Read in transcript to gene file from kb count from arguments 
tr2g = read_tsv(args_c[3], col_names = c("transcript", "gene", "gene_symbol")) %>% 
  select(gene,gene_symbol) %>%
  mutate(gene_symbol = ifelse(is.na(gene_symbol),gene,gene_symbol),
         gene_symbol = gsub("*\\.[0-9]", "",gene_symbol)) %>%
  distinct()

path_to_samples = args_c[4]

output_path = args_c[5]


for (sample in samples_list){

    #Read in kb count output
    res_mat<-read_count_output(sprintf("%s/sample_%s/counts_unfiltered", path_to_samples,sample), name = "cells_x_genes")

    # Convert from Ensembl gene ID to gene symbol
    rownames(res_mat) <- tr2g$gene_symbol[match(rownames(res_mat), tr2g$gene)]

    bc_rank<-barcodeRanks(res_mat,lower=500) # DropletUtils to find the inflection

    tot_counts <- Matrix::colSums(res_mat) # Total cell counts before filtering

    res_mat <- res_mat[, tot_counts > metadata(bc_rank)$inflection] # Filtering empty drops
    


    # Create seurat object
    seu <- CreateSeuratObject(counts = res_mat, min.cells = 3, min.feature = 200, project = sprintf("sample_%s_kb", sample))
    saveRDS(seu, file = sprintf("%s/sample_%s_kb.rds", output_path,sample))  # seu.rds is saved
    print(seu)
}

