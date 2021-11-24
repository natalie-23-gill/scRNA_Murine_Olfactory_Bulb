#!/bin/bash

# Created: 11/22/21
# Author: Christina Zakarian
# Wrapper for SCT_integrate.R which integrates SCT transformed seurat objects


#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNAseq

/usr/bin/time -v Rscript SCT_integrate.R \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/kb_rds/ \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/samples.txt \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/seurat_pipeline/combined_kb_unfiltered.rds
