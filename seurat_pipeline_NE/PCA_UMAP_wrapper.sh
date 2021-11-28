#!/bin/bash

# Created: 11/27/2021
# Author: Natalie Elphick
# wrapper script for script that outputs umap

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=PCA_UMAP_%j.out
#SBATCH --error=PCA_UMAP_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R


for i in 15 20 35 60
    do 
    pcs=$i
    for k in 0.5 0.7 0.9 0.12
    do
    /usr/bin/time -v Rscript PCA_UMAP.R \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/combined_kb_filtered.rds \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/plots/test_pca_res \
    --npcs $pcs --res $k --out PC_${pcs}_res_$k --group timepoint --split timepoint
    done
done