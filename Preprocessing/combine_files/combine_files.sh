#!/bin/bash

#Created: 10/08/2021
#Author: Natalie Elphick
#Script to combine files across lanes and flow-cells so all Read 1s and Read 2s
#from Library LXXXXX are within a single FASTQ file.


#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_1
#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_2

dir="/projects/bgmp/nelphick/bioinfo/Yu_project/Yu_Project_2021/Preprocessing/combine_files/test_files/"
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
        zcat "${flowcell}/${sample}/"*R1* >> "${out_dir}/${sample}_R1.fastq"
        zcat "${flowcell}/${sample}/"*R2* >> "${out_dir}/${sample}_R2.fastq"
    done
done

