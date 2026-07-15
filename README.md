# QIIME2 Snakemake Pipeline

A Snakemake pipeline for 16S amplicon analysis of natural microbial communities, built on QIIME2.

## 0. Setup

This branch requires SLURM and Singularity/Apptainer to be available on your cluster.

In `config.yaml`, set `singularity_image` to the path of your own QIIME2 container:

```config.yaml
singularity_image: "/path/to/your/qiime-2026.1.sif"  # <-- EDIT THIS
```

If you don't already have this image, create the container (for details, see https://library.qiime2.org/quickstart/qiime2):
```
singularity pull docker://quay.io/qiime2/amplicon:2026.1
```
or 
```
docker pull quay.io/qiime2/amplicon:2026.1
```

## Getting started

Follow these steps to prepare your input files before running the analysis pipeline:

## 1. Edit the configuration file

Open `config.yaml` and update the following:

- **`proj_name`** — set this to your project or library name.
- **Primer selection** — the config file lists several primer sets (e.g. commented-out options for different primer pairs). Uncomment the primer sequences used in your library and leave the others commented out. For now, the options include B3 and B5 primer sets.
  - B3 (341F-806R)
  - B5 (799F-1192R)
- **`pct`** — controls what fraction of reads are processed. For example, `pct: 50` runs the pipeline on a random 50% subset of reads (useful for quick test runs before a full run).

## 2. Prepare metadata files

Copy your sample metadata/mapping file into the project’s `metadata` folder and rename it to `mapping.txt`.

    ```
    cp /path/to/your/metadata.csv metadata/mapping.txt
    ```
Double-check that barcode sequences in `mapping.txt` are correct — for example, a barcode column entry might look like `AGCTGACTAGCT` (12 bp, matching your sequencing setup).
The file should have columns #SampleID, Forward_Barcode, Reverse_Barcode.

## 3. Organize raw FASTQ files

Place your raw sequencing FASTQ files into the `raw_data/` directory, following this naming convention:

- Forward reads: `sample_1.fq.gz`
- Reverse reads: `sample_2.fq.gz`

If your files come with different names, rename them after copying:

```bash
cp /path/to/your/rawdata/*fastq.gz raw_data/
cd raw_data
mv XXXXXX.fq.gz sample_1.fq.gz
mv XXXXXX.fq.gz sample_2.fq.gz
```

## 4. Checklist before running Snakemake

### `config.yaml`
- [ ] `proj_name` is set to your library/project name
- [ ] The correct primer pair is uncommented
- [ ] The correct classifier is uncommented
- [ ] `mapping_file` points to the correct path
- [ ] If subsampling reads, `pct` has been modified
- [ ] `cutadapt_error_rate: 0` is the default; adjust to 0.1–0.17 if you have low sequencing depth
- [ ] `trunc_len_f` / `trunc_len_r` default to 0; adjust based on your read quality

### Required files
- [ ] `sample_1.fq.gz` and `sample_2.fq.gz` in `raw_data/`
- [ ] `mapping.txt` in `metadata/` — validate it with [Keemei](https://keemei.qiime2.org/) before running

## 5. Run Snakemake
- It is possible to do a dry-run of snakemake, using `-n`, just to verify that all the required input files are available.
```
snakemake -n --snakefile Snakefile-bacteriapipeline
```

- If the console output does not display any message in red color it usually means that all required files to run the pipeline have already been provided and snakemake can be run. 

## Running the Pipeline

You have two options for running the pipeline, depending on your access.

### Option A: Running via SLURM (recommended for large datasets)

1. Log into your HPC cluster and navigate to your project directory.
2. Create a `logs/` directory for SLURM job logs:
```bash
   mkdir logs
```
3. Edit `run_snakemake.slurm` for your cluster's setup — at minimum, update the SLURM directives and load whatever Singularity/Apptainer module your cluster requires:
```bash
   #!/bin/bash
   #SBATCH -p normal                                          # <-- EDIT: your cluster's partition
   #SBATCH -J your_project_name                                # <-- EDIT: job name
   #SBATCH --cpus-per-task=20                                  # adjust to your needs
   #SBATCH --mem=100G                                          # adjust to your needs
   #SBATCH --output=[your_dir]/logs/your_project_name.%J.out   # <-- EDIT: log path
   #SBATCH --error=[your_dir]/logs/your_project_name.%J.err    # <-- EDIT: log path

   mkdir -p ./logs

   # Load Singularity/Apptainer if required by your cluster, e.g.:
   # module load singularity

   snakemake \
       --snakefile Snakefile-bacteriapipeline \
       --cores 32 \
       -p \
       --use-singularity \
       --singularity-args="--cleanenv"
```
4. Submit the job:
```bash
   sbatch run_snakemake.slurm
```
5. Check job status:
```bash
   squeue
```

### Option B: Running interactively (e.g. in a `screen` session)

Useful for smaller datasets or testing. Adjust `-c` to the number of cores available to you:

```bash
snakemake -c 20 -p --snakefile Snakefile-bacteriapipeline --use-singularity --singularity-args="--cleanenv"
```

`-p` prints each shell command as it runs, which is useful for troubleshooting.


## Authors and acknowledgment
Written by Magdalena W Slawinska (contact person) and inspired by scripts from José Flores-Uribe, Pengfan Zhang, and Ruben Garrido-Oter.

