# Running Cell Ranger preprocessing pipeline

Authors: Christina Zakarian, Laura Paez, Natalie Elphick   
Date: 10/19/21   

## Objectives
Perform preprocessing of single cell RNA-seq data from the olfactory bulb using the 10x Genomics Cell Ranger pipeline to perform alignment, get UMI and cell counts, and generate a gene expression count matrix.

https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger

### 1. Installation of cell ranger:
https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/installation

```
conda create --name scRNAseq python=3.8
conda activate scRNAseq
wget -O cellranger-6.1.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.1.1.tar.gz?Expires=1634477980&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjEuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MzQ0Nzc5ODB9fX1dfQ__&Signature=eaSibOib3RBIi1DAsuePUHjGKR80HqS4AqHwxLHHaYG7Eh-iLaU7yLILdek2OiMRZFGMShBUGgGNawxvaV~bnpeskLhUFr8jB-7ogmX-EnRHLXIplPRA5AYXnbJ3Ax3nmuEhon83pvS1B2aQiObsrGnTlMnrcJ0~pRkEY9JTYJ2fUkGTeSs0GeL34zNeeXey9HXRReWunweyfzMT8JAyfwx--zHPKTLgvKAvDBpdCvFUb9wlAuHnlknRdiV3HbBYtzN6TE3Pgtx5pXuSQEj~zpmnltYYVHl9sC9m4x08j0jWiyhTTWNigozgvjxcHSrj1lf2WfHh6IJMCAP-5cn7QA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar -xzvf cellranger-6.1.1.tar.gz
```

#### Version:
```
cellranger-6.1.1 
```

#### Adding Cell Ranger directory to $PATH:
Added the following command to .bashrc file in home directory on talapas to allow calling cellranger command from anywhere on command line.
```
export PATH=/projects/bgmp/czakari2/bioinformatics/yu_project/cellranger/cellranger-6.1.1:$$
```

#### Verify Installation:
```
cellranger testrun --id=tiny

...
Pipestance completed successfully!
Saving pipestance info to testrun/testrun.mri.tgz
```

### 2. Build a Custom Reference With cellranger mkref  

https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_mr  

The built in reference genome that Cell Ranger has is using an older mouse assembly (GRCm38/mm10) but we want to use the most recent version -> Mus musculus (GRCm39/mm39), so we will use cell ranger's 'mkref' function to 
build a custom genome reference from the more recent assembly. 

Max mentioned in his email that we can use either the genome reference or the transcriptome reference (inc coding and non-coding genes). We will use the genome reference since Cell ranger's examples use the genome + the transcriptome reference will require inputting 2 separate fasta files (cDNA and ncRNA) which may not be so straightforward to use with cell ranger.

#### Download the fasta and gtf files from ensembl:
```
http://ftp.ensembl.org/pub/release-104/gtf/mus_musculus/Mus_musculus.GRCm39.104.gtf.gz
http://ftp.ensembl.org/pub/release-104/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
```

#### Make a directory to store the downloaded fasta and gtf files:
```
/projects/bgmp/shared/2021_projects/Yu/mus_musculus
```

#### Confirm checksums:
```
30904 30598 Mus_musculus.GRCm39.104.gtf.gz
16996 787519 Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
```

Unzipped fasta and gtf files using gunzip before running mkref command.

#### Generate the genome reference using mkref (STAR: 2.7.2a):
```
cd /projects/bgmp/shared/2021_projects/Yu/cellranger_build

cellranger mkref 
--genome=Mus_musculus.GRCm39.dna.ens104
--fasta=/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.dna.primary_assembly.fa 
--genes=/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.104.gtf
--nthreads=8
```
Full slurm script (cr_mkref.sh) with output in slurm-16423558.out can be found in repo under .../cellranger/mkref/

#### Run cellranger on the combined FASTQ files
```
for sample in $samples
    do
    /usr/bin/time -v cellranger count \
    --id=sample_$sample \
    --transcriptome=/projects/bgmp/shared/2021_projects/Yu/cellranger_build/Mus_musculus.GRCm39.dna.ens104 \
    --fastqs=/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output \
    --sample=$sample \
    --localcores=16
done 
```
Full slurm script (cellranger_count.sh) and output files can be found in repo under .../cellranger/count/

#### Save cellranger count ouptuts as RDS objects using Seurat  

Script and relevant outputs can  be found under ../cellranger/seurat_obj

