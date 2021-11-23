#!/usr/bin/env Rscript

library(Seurat)
library(argparser)
library(tidyverse)


# Parse command line arguments 
p = arg_parser("Perform integration of SCT transformed seurat objects")
p = add_argument(p, "dir", help="Working Directory")
p = add_argument(p, "samples", help="Samples text file")
args = parse_args(p)

# Set working directory to argument path
setwd(args$dir)

# Read in sample list from arguments 
samples = read_delim(args$samples, delim="\n",col_names=FALSE) %>% pull(X1)

# Read in seurat objects
seurat_obj_kb = list()
for (i in 1:length(samples)) {
  seurat_obj_kb[[i]] = readRDS(paste0("seurat_pipeline/kb_rds/sample_", samples[i], "_kb.rds"))
}


# Use SCTransform (instead of NormalizeData) on each of the seurat objects
seurat_obj_kb <- lapply(X = seurat_obj_kb, FUN = SCTransform)

# Get the top 3000 variable features across samples
features <- SelectIntegrationFeatures(object.list = seurat_obj_kb, nfeatures = 3000)

# Prepare list of SCT transformed seurat objects for integration (checks feature residuals and some other things)
seurat_obj_kb <- PrepSCTIntegration(object.list = seurat_obj_kb, anchor.features = features)

# Identifies anchors across set of seurat objects to use for integration
anchors <- FindIntegrationAnchors(object.list = seurat_obj_kb, normalization.method = "SCT", anchor.features = features)

# integrate 
combined.sct <- IntegrateData(anchorset = anchors, normalization.method = "SCT")


# Save combined seurat object
saveRDS(combined.sct, file = "seurat_pipeline/combined_kb_unfiltered.rds")  
print(combined.sct)