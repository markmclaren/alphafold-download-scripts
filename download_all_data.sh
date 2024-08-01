#!/bin/bash
set -e

if [[ $# -eq 0 ]]; then
    echo "Error: download directory must be provided as an input argument."
    exit 1
fi

if ! command -v aria2c &>/dev/null; then
    echo "Error: aria2c could not be found. Please install aria2c (sudo apt install aria2)."
    exit 1
fi

DOWNLOAD_DIR="$1"
DOWNLOAD_MODE="${2:-full_dbs}" # Default mode to full_dbs.
if [[ "${DOWNLOAD_MODE}" != full_dbs && "${DOWNLOAD_MODE}" != reduced_dbs ]]; then
    echo "Error: DOWNLOAD_MODE ${DOWNLOAD_MODE} not recognized. Use 'full_dbs' or 'reduced_dbs'."
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
FLAG_FILE="${DOWNLOAD_DIR}/.download_all_complete"

mkdir -p "${DOWNLOAD_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "All databases already downloaded and processed."
    exit 0
fi

download_database() {
    local script_name="$1"
    local db_name="$2"
    local flag_file="${DOWNLOAD_DIR}/${db_name}/.download_complete"

    if [ -f "${flag_file}" ]; then
        echo "${db_name} database already downloaded and processed."
    else
        echo "Downloading and processing ${db_name} database..."
        bash "${SCRIPT_DIR}/${script_name}" "${DOWNLOAD_DIR}"
    fi
}

# AlphaFold parameters
download_database "download_alphafold_params.sh" "params"

# BFD or Small BFD
if [[ "${DOWNLOAD_MODE}" = reduced_dbs ]]; then
    download_database "download_small_bfd.sh" "small_bfd"
else
    download_database "download_bfd.sh" "bfd"
fi

# MGnify
download_database "download_mgnify.sh" "mgnify"

# PDB70
download_database "download_pdb70.sh" "pdb70"

# PDB mmCIF files
download_database "download_pdb_mmcif.sh" "pdb_mmcif"

# Uniref30
download_database "download_uniref30.sh" "uniref30"

# Uniref90
download_database "download_uniref90.sh" "uniref90"

# UniProt
download_database "download_uniprot.sh" "uniprot"

# PDB SeqRes
download_database "download_pdb_seqres.sh" "pdb_seqres"

touch "${FLAG_FILE}"
echo "All databases downloaded and processed successfully."
