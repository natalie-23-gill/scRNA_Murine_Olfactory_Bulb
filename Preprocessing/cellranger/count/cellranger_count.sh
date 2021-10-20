#!/bin/bash

# Created: 10/18/2021
# Author: Natalie Elphick
# Script to run cellranger count on combined sample files

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=cr_count_%j.out
#SBATCH --error=cr_count_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

dir="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/"
out_dir="cr_count_output"

samples = "L35463 L35464 L35465 L35466 L35467 L35468 L35469 L35470 L35472 L35471"

cd $dir
mkdir $out_dir
cd $out_dir

for sample in $samples
    do
        /usr/bin/time -v cellranger count --id=sample_$sample \
        --transcriptome=/projects/bgmp/shared/2021_projects/Yu/cellranger_build/Mus_musculus.GRCm39.dna.ens104 \
        --fastqs=/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output \
        --sample=$sample \
        --localcores=16
done

pigz -p 16 -r sample_*