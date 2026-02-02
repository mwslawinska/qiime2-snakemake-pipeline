# bacteria_snakemake_pipeline_novogene

This pipeline was created for 16S natural communities sequenced at Novogene.

Follow these steps to prepare your input files before running the analysis pipeline:

## 0. Make sure you have micromamba and the environment installed and running

- If you haven't installed it go into env folder and follow `README_install_micromamba.md` instructions.
- If you have already installed it, activate the environemnt.
```
micromamba activate qiime-2024.10-Syncom
```


## 1. Edit the Config File

- Open the configuration file `config.yaml` for your project.
- Update the `proj_name` field with your current library or project name.
- Identify the primer section (e.g., B3 or B5).
  - Uncomment the primer sequences used in this library.
  - Comment out primer sequences not used.
- Ensure the reference fasta file name is correctly specified under the appropriate key in the config file (e.g., `reference: metadata/reference.fasta`).
- If running only a subset of the library through the pipeline, then modify the `pct` value (e.g., `pct: 50` means to use only 50% of the total reads).

## 2. Prepare Metadata Files

- Copy your sample metadata/mapping file into the project’s `metadata` folder.
  - The file should be renamed to `mapping.txt`.
  - Make sure you use correct barcodes! (e.g. TACAGCGCATAC, no "AC" at the beginning)
  - Example:
    ```
    cp /path/to/your/metadata.csv metadata/mapping.txt
    ```

## 3. Organize Raw FASTQ Files

- Place your raw sequencing FASTQ files into the `untrimmed_raw_data` directory.
- The files must follow this naming convention:
  - Forward reads (`XXXXXXXXX_1.fq.gz`) : `sample_1.fq.gz`
  - Reverse reads (`XXXXXXXXX_2.fq.gz`) : `sample_2.fq.gz`
- If renaming is necessary, do so after copying:
    ```
    cp /path/to/your/rawdata/*fastq.gz untrimmed_raw_data/
    cd untrimmed_raw_data
    mv XXXXXX.fq.gz sample_1.fq.gz
    mv XXXXXX.fq.gz sample_2.fq.gz
    ```

## 4. Checklist before running Snakemake

### Micromamba
- [] Is the `qiime-2024.10-Syncom` environment active. If not, run `micromamba activate qiime-2024.10-Syncom`

### `config.yaml`

- [] Library name has been stored into `proj_name`
- [] Either B3 or B5 primers are uncommented
- [] The correct classifier is uncommented
- [] There is a correct path to the 'mapping_file'
- [] If subsampling reads, make sure `pct` has been modified
- [] cutadapt_error_rate: 0 is suggested, but you can change it to 0.1/0.17 if you have low depths
- [] trunc_len_f and trunc_len_r are set to 0; they can be adapted based on the quality of your reads

### Required files
- [] `sample_1.fq.gz` and `sample_2.fq.gz` stored in folder `untrimmed_raw_data`
- [] `mapping.txt` file , stored in folder `metadata`. Don't forget to check the mapping file using a tool like [Keemei](https://keemei.qiime2.org/).

## 5. Run Snakemake
- It is possible to do a dry-run of snakemake, using `-n`, just to verify that all the required input files are available.
```
snakemake -n --snakefile Snakefile-SynCom
```

- If the console output does not display any message in red color it usually means that all required files to run the pipeline have already been provided and snakemake can be run. 

You have two options to run the pipeline:

### 5a. Running from hpc nodes (faster)

Log into hpc (put the number instead of hpcXX, e.g. hpc01):
```
ssh <user>@hpcXX.mpipz.mpg.de
```
Go to your project directory.
In your project directory, `mkdir logs` for slurm logs (will tell you if the job crashes).

Edit `run_snakemake.slurm`:
```
#!/bin/bash
#SBATCH -p normal
#SBATCH -J your_project_name <-- EDIT THIS
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G
#SBATCH --output=[your_dir]/logs/your_project_name.%J.out <-- EDIT THIS
#SBATCH --error=[your_dir]/logs/your_project_name.%J.err <-- EDIT THIS
# Activate the environment
source ~/.bashrc
micromamba activate qiime-2024.10-Syncom
# Run Snakemake 
snakemake -c 20 -p --snakefile Snakefile-bacteriapipeline
```
- you might change `#SBATCH --cpus-per-task=` and `#SBATCH --mem=100G` if needed.

Run the job:
```
sbatch run_snakemake.slurm
```

If you want to check if it's running, you can do `squeue`.

### 5b. Running from your node (screen)
In this example we will use 20 cores ( `-c 20` ) for the pipeline. It's recommended to run with option `-p` to print into the console the actual command being run as it could help with troubleshooting.
```
snakemake -c 20 -p --snakefile Snakefile-SynCom
```

## Authors and acknowledgment
Written by Magdalena W Slawinska (contact person) and inspired by scripts from José Flores-Uribe, Pengfan Zhang, and Ruben Garrido-Oter.

