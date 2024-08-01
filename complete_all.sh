#!/bin/bash

# Usage: ./complete_all.sh <DOWNLOAD_DIR> [<DOWNLOAD_MODE>]
# Example: ./complete_all.sh /path/to/download_dir reduced_dbs
# This script creates a .download_complete file in the appropriate directory
# based on the specified download mode.

DOWNLOAD_DIR="\$1"             # Parent directory for the download process
DOWNLOAD_MODE="${2:-full_dbs}" # Default mode to full_dbs if not provided

# List of directories to create .download_complete files in
DIRECTORIES=("params" "mgnify" "pdb70" "pdb_mmcif")

# DIRECTORIES=("params" "mgnify" "pdb70" "pdb_mmcif" "uniref30" "uniref90" "uniprot" "pdb_seqres")

# Create .download_complete files in each directory
for dir in "${DIRECTORIES[@]}"; do
    touch "$DOWNLOAD_DIR/$dir/.download_complete"
done

# Determine the target directory based on download_mode
if [[ "${DOWNLOAD_MODE}" = "reduced_dbs" ]]; then
    TARGET_DIR="small_bfd"
else
    TARGET_DIR="bfd"
fi

# Create the .download_complete file in the target directory
touch "$DOWNLOAD_DIR/$TARGET_DIR/.download_complete"
