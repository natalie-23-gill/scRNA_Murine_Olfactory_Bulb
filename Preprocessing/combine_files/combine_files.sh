#!/bin/bash

#SBATCH --partition=bgmp        ### Partition (like a queue in PBS)
#SBATCH --job-name=combine_files  ### Job Name
#SBATCH --output=combine_files_%j.out         ### File in which to store job output
#SBATCH --error=combine_files_%j.err          ### File in which to store job error messages
#SBATCH --time=0-01:01:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1              ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=8     ### Number of tasks to be launched per node
#SBATCH --account=bgmp      ### Account used for job submission






#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_1
#/projects/bgmp/shared/2021_projects/Yu/BGMP_2021/flowcell_2