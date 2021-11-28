#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# wrapper script for subset script that filters seurat objects based on specified cutoffs

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=QC_subset_%j.out
#SBATCH --error=QC_subset_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

/usr/bin/time -v Rscript QC_subset.R \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds_filtered \
/projects/bgmp/nelphick/bioinfo/Yu_project/Yu_Project_2021/data/timepoints.csv \
10000 200 7

