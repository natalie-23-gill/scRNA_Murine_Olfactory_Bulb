#!/usr/bin/env Rscript
library(Seurat)
library(argparser)
library(tidyverse)

# Parse command line arguments 
p = arg_parser("Filter a list of RDS seurat objects using the same cutoffs for each object")
p = add_argument(p, "data", help="RDS object containing SCT integrated seurat object")
p = add_argument(p, "out_dir", help="Directory for ouput plots to be saved")
