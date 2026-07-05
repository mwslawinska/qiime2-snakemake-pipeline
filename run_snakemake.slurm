#!/bin/bash
#SBATCH -p normal                   # Partition / queue
#SBATCH -J your_job_name            # Job name
#SBATCH --cpus-per-task=32          # Number of CPU cores
#SBATCH --mem=100G                  # Total memory
#SBATCH --output=./logs/%x.%J.out   # Standard output
#SBATCH --error=./logs/%x.%J.err    # Standard error

# Make sure logs directory exists
mkdir -p ./logs

# Activate environment if needed
# Load your institution's Singularity module here, e.g.:
# module load singularity

# Run Snakemake workflow
# -p: print each shell command
# --use-singularity: use the Singularity image specified in each rule
# --rerun-incomplete: resume workflow if interrupted
snakemake \
    --snakefile Snakefile-bacteriapipeline \
    --cores 32 \
    -p \
    --use-singularity \
    --singularity-args="--cleanenv"
