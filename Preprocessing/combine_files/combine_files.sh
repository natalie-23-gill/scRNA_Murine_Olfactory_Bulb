#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00


#Created: 10/08/2021
#Author: Natalie Elphick
#Script to combine files across lanes and flow-cells so all Read 1s and Read 2s
#from Library LXXXXX are within a single FASTQ file.



# Test files
# /projects/bgmp/nelphick/bioinfo/Yu_project/Yu_Project_2021/Preprocessing/combine_files/test_files/


dir="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/"
f1="flowcell_1"
f2="flowcell_2"
samples="$(ls -1 $dir$f1 | grep -v '.txt$')"
out_dir="combined_files_output"

cd $dir
mkdir $out_dir

for flowcell in $f1 $f2
    do
    for sample in $samples
        do
        zcat "${flowcell}/${sample}/"*R1* >> "${out_dir}/${sample}_S1_L001_R1_001.fastq"
        zcat "${flowcell}/${sample}/"*R2* >> "${out_dir}/${sample}_S1_L001_R2_001.fastq"
    done
done

cd $out_dir
pigz -p 16 *