#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# wrapper script for seurat intergrated analysis pipeline

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=seurat_pipeline_%j.out
#SBATCH --error=seurat_pipeline_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64G
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

/usr/bin/time -v Rscript QC_subset.R \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds_filtered \
/projects/bgmp/nelphick/bioinfo/Yu_project/scRNA_Murine_Olfactory_Bulb/data/timepoints.csv

/usr/bin/time -v Rscript SCT_integrate.R \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds_filtered \
/projects/bgmp/nelphick/bioinfo/Yu_project/scRNA_Murine_Olfactory_Bulb/data/timepoints.txt \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/combined_kb_filtered.rds
