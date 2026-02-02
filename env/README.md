# README_install_micromamba.md

# Micromamba Installation on Server

This guide describes how to install and initialize micromamba on the server, storing environments on netscratch. Attention, `USER` must be replaced by your current username in the server.

## Prerequisites

- SSH access to a dell-node-server

## Steps

1. SSH into the target node
    
    ```bash
    ssh <user>@dell-node-XX
    ```
    
2. Create a software directory on netscratch
    
    ```bash
    cd /netscratch/dep_psl/grp_rgo/USER
    mkdir -p software
    cd software
    ```
    
3. Download micromamba (per official docs)
    
    ```bash
    curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
    # micromamba binary will be in ./bin/micromamba
    ```
    
4. Initialize micromamba and set the environments directory on netscratch
    
    ```bash
    # This sets the envs root to /netscratch/dep_psl/grp_rgo/USER/software/micromamba_environments
    ./bin/micromamba shell init -s bash -r /netscratch/dep_psl/grp_rgo/USER/software/micromamba_environments
    ```
    
5. Ensure `.profile` sources `.bashrc`
    
    Edit `~/.profile` and make sure it includes:
    
    ```bash
    # read micromamba conf
    source ~/.bashrc
    ```
    
6. Reload shell configuration
    
    ```bash
    source ~/.profile
    # or log out and log back in
    ```
    
7. Verify installation by running the following command. Expected output should be at least 2.3.3
    
    ```bash
    micromamba --version
    ```
    
8. Set Up the Conda Environment from the YAML File

   With micromamba installed, you can now create the environment specified by the YAML file. Make sure that the file `qiime2-amplicon-2024.10-py310-linux-conda-MPIPZ.yml` is in your current directory or specify its full path. This is a modified version of the original QIIME yml file modified to run in the MPIPZ servers by removing the line of c-ares and adding lines to install snakemake-minimal, r-devtools, and rbec.

   To create the environment:

    ```bash
    #cd to pipeline folder and then to subfolder env
    micromamba env create -f qiime2-amplicon-2024.10-py310-linux-conda-MPIPZ.yml
    ```

   This command reads the YAML file and creates the environment with its specified packages and channels. Please note that the version of Rbec installed does not generates normalized count tables.

9. Activate the New Environment

   Once the environment is created, activate it with:

    ```bash

    micromamba activate qiime-2024.10-Syncom
    ```

10. Validate the Environment

    With your environment activated, check that the expected packages are installed by running a package listing command. For example, if you want to check a particular package:
    
    ```bash
    micromamba list snakemake-minimal
    ```

    or start an interactive session (shell, R, Python as appropriate) to confirm functionality.
## Notes

- The example envs directory:
    
    ```
    /netscratch/dep_psl/grp_rgo/USER/software/micromamba_environments
    ```
    
- If `micromamba` is not found after initialization, confirm your shell is bash and that `~/.bashrc` modifications (from the init step) were applied.

## Troubleshooting

- If `micromamba` only runs from `./bin/micromamba`:
    - Open a new shell or `source ~/.profile` to load the PATH changes added by the init step.
- If environments are created elsewhere:
    - Re-run the init command with the correct `-r` path and reload your shell.