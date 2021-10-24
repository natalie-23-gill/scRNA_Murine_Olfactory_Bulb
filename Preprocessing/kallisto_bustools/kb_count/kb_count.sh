#!/bin/bash

# Created: 10/23/2021
# Author: Natalie Elphick
# kb count on all 10 samples

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --output=kb_count_%j.out
#SBATCH --error=kb_count_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

conda activate scRNA

dir="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/"
out_dir="kb_count_output"

samples="L35463 L35464 L35465 L35466 L35467 L35468 L35469 L35470 L35472 L35471"

cd $dir
mkdir $out_dir
cd $out_dir

for sample in $samples
    do
    mkdir sample_$sample
    /usr/bin/time -v kb count -i /projects/bgmp/nelphick/bioinfo/Yu_project/kallisto/mus_musculus_index/transcriptome.idx \
    -g /projects/bgmp/nelphick/bioinfo/Yu_project/kallisto/mus_musculus_index/transcripts_to_genes.txt \
    -x 10xv2 -t 16 --cellranger --filter -o sample_$sample \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output/${sample}_S1_L001_R1_001.fastq.gz \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output/${sample}_S1_L001_R2_001.fastq.gz
done

pigz -p 16 -r sample_*