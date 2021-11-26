#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# wrapper script for seurat integrated analysis

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=kb_ref_%j.out
#SBATCH --error=kb_ref_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA_R

