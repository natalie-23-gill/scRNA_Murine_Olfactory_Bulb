#!/usr/bin/env Rscript
library(Seurat)
library(argparser)
library(tidyverse)

# Parse command line arguments 
p = arg_parser("Filter a list of RDS seurat objects using the same cutoffs for each object")
p = add_argument(p, "data_dir", help="Directory containing the RDS objects to filter")
p = add_argument(p, "out_dir", help="Directory for filtered output files to be saved")
p = add_argument(p, "samples", help="Samples csv with 2 columns |Timepoint|Sample|")
p = add_argument(p, "max_count", help="Maximum cutoff for nCount_RNA")
#p = add_argument(p, "min_count", help="Minimum cutoff for nCount_RNA")
p = add_argument(p, "min_features", help="Minimum cutoff for nFeature_RNA")
#p = add_argument(p, "max_features", help="Maximum cutoff for nFeature_RNA")
#p = add_argument(p, "max_mito", help="Maximum cutoff for percent mitochondrial genes")
args = parse_args(p)


labels = read_csv(args$samples)

timepoints = labels$Timepoint
samples = labels$Sample


seurat_obj_kb = list()

print("Pre filtering Cell Counts:")
for (i in 1:length(samples)) {

  # Read in seurat objects
  seurat_obj_kb[[i]] = readRDS(paste0(args$data_dir,"/sample_",samples[i],"_kb.rds"))
  seurat_obj_kb[[i]]$timepoint <- timepoints[i]
  # Print cell counts
  print(paste(timepoints[i],dim(seurat_obj_kb[[i]])[2]))

}

for (i in 1:length(seurat_obj_kb)){
  
  seurat_obj_kb[[i]][["percent.mt"]] <- PercentageFeatureSet(seurat_obj_kb[[i]], pattern = "^mt-")
  
  
}

print("Post filtering Cell Counts:")
for (i in 1:length(seurat_obj_kb)){
    # Subset using arguments for cutoffs
    ## Get filtering parameters
    count.max <- round(mean(seurat_obj_kb[[i]]$nCount_RNA) + 3 * sd(seurat_obj_kb[[i]]$nCount_RNA), digits = -2)
    count.min <- round(mean(seurat_obj_kb[[i]]$nCount_RNA) - 3 * sd(seurat_obj_kb[[i]]$nCount_RNA), digits = -2)
    feat.max <- round(mean(seurat_obj_kb[[i]]$nFeature_RNA) + 3 * sd(seurat_obj_kb[[i]]$nFeature_RNA), digits = -2)
    feat.min <- round(mean(seurat_obj_kb[[i]]$nFeature_RNA) - 3 * sd(seurat_obj_kb[[i]]$nFeature_RNA), digits = -2)
  
    # Filter out percent mitochondrial genes above the 99.9th percentile
    max.mito <- quantile(seurat_obj_kb[[i]]@meta.data[["percent.mt"]],probs = .999)

    ## Set minimum parameters to 0 if negative value
    if (count.min < 0){
      count.min <- 0
      } else {
        count.min <- count.min}
    
    if (feat.min < 0){
      feat.min <- 0
      } else {
        feat.min <- feat.min}
  
    ## Filter cells
    seurat_obj_kb[[i]] <- subset(seurat_obj_kb[[i]],
                              subset = nFeature_RNA > feat.min & nFeature_RNA < feat.max & nCount_RNA < count.max & nCount_RNA > count.min & percent.mt < max.mito)
    print(paste(timepoints[i],dim(seurat_obj_kb[[i]])[2]))
 
}

for (i in 1:length(seurat_obj_kb)){

    saveRDS(seurat_obj_kb[[i]],file=paste0(args$out_dir,"/sample_",timepoints[i],".rds"))

}

