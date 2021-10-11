#!/bin/bash

#Created: 10/08/2021
#Author: Natalie Elphick
#Script to combine files across lanes and flow-cells so all Read 1s and Read 2s
#from Library LXXXXX are within a single FASTQ file.


#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_1
#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_2

# specify the directories of the flowcells 
f1="/mnt/c/Users/natal/BGMP/bioinformatics/Yu_Project_2021/Preprocessing/combine_files/test_files/flowcell_1/"
f2="/mnt/c/Users/natal/BGMP/bioinformatics/Yu_Project_2021/Preprocessing/combine_files/test_files/flowcell_2/"

out_dir="/mnt/c/Users/natal/BGMP/bioinformatics/Yu_Project_2021/Preprocessing/combine_files/output"

mkdir $out_dir

for dir in $f1 $f2
    do
    cd $dir
    # List of LibraryIDs 
    samples="$(ls -1 $dir | grep -v '.txt$')"
    for sample in $samples
        do
        cd $sample
        files=$(ls -1 $dir$sample | grep -v '.txt$')
        for file in $files
            do
            zcat *R1* >> "${out_dir}/${sample}_R1.fq"

        done
    done
    
done


