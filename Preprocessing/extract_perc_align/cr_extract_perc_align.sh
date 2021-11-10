#!/usr/bin/bash

# Created: 11/10/2021
# Author: Christina Zakarian
# Script to extract percent alignment metric from cellranger output for all samples
# Output: csv file containing the % alignment per sample

# specify the input/outputs
dir="/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/cr_count_output"
outdir="/projects/bgmp/czakari2/bioinformatics/Yu_Project_2021/Preprocessing/extract_perc_align/cr_align_out.csv"

# get list of sample directories
samples="$(ls -1 $dir)"

for sample in $samples
    do
    file=$dir/$sample/outs/metrics_summary.csv.gz

    # get sample name 
    s=$(echo $sample | cut -d '_' -f 2)
    # get percent aligned
    perc=$(zcat $file | cut -f 11 -d "," | sed -n '2p')

    echo $s","$perc  >> $outdir
done
