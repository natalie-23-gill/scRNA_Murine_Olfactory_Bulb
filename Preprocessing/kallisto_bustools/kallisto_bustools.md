# Running kallisto | bustools preprocessing pipeline

Authors: Christina Zakarian, Laura Paez, Natalie Elphick   
Date: 11/8/21   

## Objectives
Perform preprocessing of single cell RNA-seq data from the olfactory bulb using the kallisto | bustools pipeline to perform pseudoalignment, get UMI and cell counts, and generate a gene expression count matrix.

https://www.kallistobus.tools/

### 1. Installation of kb tools:
https://www.kallistobus.tools/kb_usage/kb_usage/

```
conda create --name scRNA
conda activate scRNA
pip install kb-python
```

#### Version:
```
kb-python 0.26.4
```

### 2. Build a Custom Index With kb ref  

https://www.kallistobus.tools/kb_usage/kb_ref/  


Since we want to compare both of the pipelines, we use the same input files for this step as the cellranger mkref step.  
  

### Input files
```
http://ftp.ensembl.org/pub/release-104/gtf/mus_musculus/Mus_musculus.GRCm39.104.gtf.gz
http://ftp.ensembl.org/pub/release-104/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
```
### Command:  
```
/usr/bin/time -v kb ref -i /projects/bgmp/shared/2021_projects/Yu/kb_ref_index/transcriptome.idx \
-g /projects/bgmp/shared/2021_projects/Yu/kb_ref_index/transcripts_to_genes.txt \
-f1 /projects/bgmp/shared/2021_projects/Yu/kb_ref_index/cdna.fa \
/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.dna.primary_assembly.fa \
/projects/bgmp/shared/2021_projects/Yu/mus_musculus/Mus_musculus.GRCm39.104.gtf

```
Full slurm script (kb_ref.sh) with run details in kb_ref_16550486.err can be found in this repo under .../kallisto_bustools/kb_ref .

### 3. Use kb count to preform pseudo alignment and obtain count matrix  

```
for sample in $samples
    do
    mkdir sample_$sample
    /usr/bin/time -v kb count -i /projects/bgmp/shared/2021_projects/Yu/kb_ref_index/transcriptome.idx \
    -g /projects/bgmp/shared/2021_projects/Yu/kb_ref_index/transcripts_to_genes.txt \
    -x 10xv2 -t 16 --filter -o sample_$sample \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output/${sample}_S1_L001_R1_001.fastq.gz \
    /projects/bgmp/shared/2021_projects/Yu/BGMP_2021/combined_files_output/${sample}_S1_L001_R2_001.fastq.gz
done

```

Full script (kb_count.sh) with run details in kb_count_16503154.err can be found in this repo under .../kallisto_bustools/kb_count  .


### 4. Create kb_filter.R script to filter out empty droplets from the count matrix results and save them as seurat RDS objects for downstream comparison with cellranger   

This kb_filter.R script was adapted from the code in the following vignette:   

https://www.kallistobus.tools/tutorials/kb_getting_started/r/kb_intro_2_r/   


It takes the raw count matrix, uses DropletUtils::barcodeRanks(), with lower=500 to filter empty droplets and saves the output as RDS objects to compare count metrics per the following paper:

https://doi.org/10.1186/s12864-021-07930-6

