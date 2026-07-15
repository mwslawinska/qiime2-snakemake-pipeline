# QIIME2 Snakemake Pipeline

A Snakemake pipeline for 16S amplicon analysis of natural microbial communities, built on QIIME2 2026.1.

**Branches:**
- `main` — runs locally via conda/micromamba, no HPC access required
- `hpc` — template for SLURM + Singularity/Apptainer clusters

## 0. Setup

Create the conda/micromamba environment from the provided file:

```bash
conda env create -f environment.yml
# or: micromamba create -f environment.yml

conda activate qiime2-amplicon-2026.1
# or: micromamba activate qiime2-amplicon-2026.1
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

Activate the conda/micromamba environment:

```bash
conda activate qiime2-amplicon-2026.1
# or: micromamba activate qiime2-amplicon-2026.1
```

Do a dry-run first to confirm all required inputs are available:

```bash
snakemake -n --snakefile Snakefile-bacteriapipeline
```

If the output shows no red error messages, all required files are present and you're ready to run.

Run the pipeline (adjust core count as needed):

```bash
snakemake -c 20 -p --snakefile Snakefile-bacteriapipeline
```

`-p` prints each shell command as it runs, which helps with troubleshooting.

## Authors and acknowledgment
Written by Magdalena W Slawinska (contact person) and inspired by scripts from José Flores-Uribe, Pengfan Zhang, and Ruben Garrido-Oter.

