#!/usr/bin/env Rscript
library(Seurat)
library(argparser)
library(tidyverse)

# Parse command line arguments 
p = arg_parser("Filter a list of RDS seurat objects using the same cutoffs for each object")
p = add_argument(p, "--data_dir", help="Directory containing the RDS objects to filter")
#p = add_argument(p, "--samples", help="Samples csv with 2 columns |Timepoint|Sample|")
#p = add_argument(p, "--max_count", help="Maximum cutoff for nCount_RNA")
#p = add_argument(p, "--min_count", help="Minimum cutoff for nCount_RNA")
#p = add_argument(p, "--min_features", help="Minimum cutoff for nFeature_RNA")
#p = add_argument(p, "--max_features", help="Maximum cutoff for nFeature_RNA")
#p = add_argument(p, "--max_mito", help="Maximum cutoff for percent mitochondrial genes")
args = parse_args(p)

#setwd(args$data_dir)

#samples = read_csv(args$samples)

print(args$data_dir)

