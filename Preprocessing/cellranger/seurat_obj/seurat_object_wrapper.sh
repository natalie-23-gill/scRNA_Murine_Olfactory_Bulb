#!/bin/bash

# Created: 10/31/2021
# Author: Natalie Elphick and Christina Zakarian
# Create and save seurat objects from cellranger count output

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=seurat_obj_%j.out
#SBATCH --error=seurat_obj_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

# Arguements must be supplied in the order seen here
/usr/bin/time -v Rscript seurat_object.R /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/cr_count_output \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/samples.txt \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/cr_rds