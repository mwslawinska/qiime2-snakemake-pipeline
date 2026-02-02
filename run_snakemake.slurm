#!/bin/bash
#SBATCH -p normal
#SBATCH -J your_project_name
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G
#SBATCH --output=[your_dir]/logs/your_project_name.%J.out
#SBATCH --error=[your_dir]/logs/your_project_name.%J.err
# Activate the environment
source ~/.bashrc
micromamba activate qiime-2024.10-Syncom
# Run Snakemake 
snakemake -c 20 -p --snakefile Snakefile-bacteriapipeline