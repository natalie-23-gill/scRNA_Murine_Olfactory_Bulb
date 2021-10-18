#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00

cd /projects/bgmp/shared/2021_projects/Yu/cellranger_build/

/usr/bin/time -v cellranger mkref \
--genome=Mus_musculus.GRCm39.dna.ens104 \
--fasta=/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.dna.primary_assembly.fa \
--genes=/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.104.gtf \
--nthreads=8