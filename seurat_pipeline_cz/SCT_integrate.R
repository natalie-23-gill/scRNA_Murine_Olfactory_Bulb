#!/usr/bin/env Rscript

library(argparser)

# Parse command line arguments 
p = arg_parser("Performs integration of datasets after normalizing with SCTransform")
p = add_argument(p, "dir", help="Directory containing RDS objects to sctranform and integrate")
p = add_argument(p, "samples", help="Text file with sample names")
p = add_argument(p, "output", help="File to output integrated object")
args = parse_args(p)

library(Seurat)
library(tidyverse)

# Set working directory to argument path
setwd(args$dir)

# Read in sample list from arguments 
samples = read_delim(args$samples, delim="\n",col_names=FALSE) %>% pull(X1)

# Read in seurat objects
seurat_obj_kb = list()
for (i in 1:length(samples)) {
  seurat_obj_kb[[i]] = readRDS(paste0("sample_", samples[i], "_kb.rds"))
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
saveRDS(combined.sct, file = args$output)  
print(combined.sct)