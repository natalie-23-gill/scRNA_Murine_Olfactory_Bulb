#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# Make kb index

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=kb_ref_%j.out
#SBATCH --error=kb_ref_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA

/usr/bin/time -v kb ref -i /projects/bgmp/nelphick/bioinfo/Yu_project/kallisto/mus_musculus_index/transcriptome.idx \
-g /projects/bgmp/nelphick/bioinfo/Yu_project/kallisto/mus_musculus_index/transcripts_to_genes.txt \
-f1 /projects/bgmp/nelphick/bioinfo/Yu_project/kallisto/mus_musculus_index/cdna.fa \
/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.dna.primary_assembly.fa \
/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.104.gtf
