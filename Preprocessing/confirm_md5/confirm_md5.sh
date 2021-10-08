#!/usr/bin/bash

# Created: 10/08/2021
# Author: Christina Zakarian
# Script to check md5sum against provided md5sums on downloaded FASTQ files in each of the 2 flowcell directories
# Output: text file containing the md5sums (md5_output.txt), 
#         if any discrepancies found, differences will be printed to terminal 

# specify the directories of the flowcells 
f1="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_1/"
f2="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_2/"

for dir in $f1 $f2
    do
    cd $dir
    # grab a list of the sample folder names 
    samples="$(ls -1 $dir)"
    for sample in $samples
        do
        files=$(ls -1 $dir$sample | grep -v '.txt$')
        for file in $files
            do
            md5val=$(md5sum "${sample}/$file")
            echo $md5val >> md5_output.txt
        done
    done
    # output any differences in md5sums // ignoring whitespace 
    diff -b md5_output.txt md5sum.txt
done
