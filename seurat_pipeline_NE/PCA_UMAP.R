#!/usr/bin/env Rscript


library(argparser)
# Parse command line arguments 
p = arg_parser("Filter a list of RDS seurat objects using the same cutoffs for each object")
p = add_argument(p, "data", help="RDS object containing SCT integrated seurat object")
p = add_argument(p, "out_dir", help="Directory for output plots to be saved")
p = add_argument(p, "--npcs", help = "Number of principal componets for PCA and UMAP",default=15)
p = add_argument(p, "--res", help = "Specify resolution for FindClusters function",default=.5)
p = add_argument(p, "--out", help = "Name for output folder",default="ouput_plots")
p = add_argument(p, "--group", help = "If provided the script will output plots with this input for the group.by",default="")
p = add_argument(p, "--split", help = "If provided the script will output plots with this input for the split.by",default="")
args = parse_args(p)

library(Seurat)
library(tidyverse)

combined.sct = readRDS(args$data)
DefaultAssay(combined.sct) = "integrated"

# Standard workflow for visualization and clustering with cpmmandline parameters
combined.sct = ScaleData(combined.sct, verbose = FALSE)
combined.sct = RunPCA(combined.sct, npcs = as.numeric(args$npcs), verbose = FALSE)
combined.sct = RunUMAP(combined.sct, reduction = "pca", dims = 1:args$npcs)
combined.sct= FindNeighbors(combined.sct, reduction = "pca", dims = 1:args$npcs)
combined.sct = FindClusters(combined.sct, resolution = args$res)

setwd(args$out_dir)
dir.create(args$out)
setwd(args$out)

# Check if --group arguement is provided
if(args$group == "") {
   # If not just output the single umap and check if --split is set
   p1 = DimPlot(combined.sct, reduction = "umap", label = TRUE, repel = TRUE)
   ggsave("umap.png",p1)
   if (args$split != "") {
      p3 = DimPlot(combined.sct, reduction = "umap", split.by = args$split, combine = FALSE)
      for (i in p3){
         print(i)
         fn = paste0("umap_",i,".png")
         ggsave(fn,p3[i])
      }
   }

} else if (args$split == "") {
   p1 = DimPlot(combined.sct, reduction = "umap", label = TRUE, repel = TRUE)
   p2 = DimPlot(combined.sct, reduction = "umap", group.by = args$group)
   ggsave("umap.png",p1)
   ggsave("umap_grouped.png",p2)
} else {
   p1 = DimPlot(combined.sct, reduction = "umap", label = TRUE, repel = TRUE)
   p2 = DimPlot(combined.sct, reduction = "umap", group.by = args$group)
   p3 = DimPlot(combined.sct, reduction = "umap", split.by = args$split, combine = FALSE)
   p3 = DimPlot(combined.sct, reduction = "umap", split.by = "timepoint",ncol = 2)
   ggsave("umap.png",p1)
   ggsave("umap_grouped.png",p2)
   ggsave("umap_split.png",p3,width = 7,height = 9)
}
