#!/bin/bash

# Created: 10/31/2021
# Author: Natalie Elphick and Laura Paez
# Filter empty droplets from kb count output and save as seurat objects

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=kb_filter_%j.out
#SBATCH --error=kb_filter_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

# Arguements must be supplied in the order seen here

/usr/bin/time -v Rscript kb_filter.R /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/ \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/samples.txt \
/projects/bgmp/shared/2021_projects/Yu/kb_ref_index/transcripts_to_genes.txt \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/kb_count_output \
/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/kb_rds