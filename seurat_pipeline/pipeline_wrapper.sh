#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# wrapper script for seurat integrated analysis

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=seurat_pipeline_%j.out
#SBATCH --error=seurat_pipeline_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

/usr/bin/time -v Rscript QC_subset.R \
-data_dir /home/natgill/BGMP/bioinformatics/Yu_Project_2021

