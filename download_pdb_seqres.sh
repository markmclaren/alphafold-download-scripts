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
ROOT_DIR="${DOWNLOAD_DIR}/pdb_seqres"
SOURCE_URL="https://files.wwpdb.org/pub/pdb/derived_data/pdb_seqres.txt"
BASENAME=$(basename "${SOURCE_URL}")
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "PDB SeqRes database already downloaded and processed."
    exit 0
fi

echo "Downloading PDB SeqRes database..."
aria2c "${SOURCE_URL}" --dir="${ROOT_DIR}" --continue=true

echo "Processing PDB SeqRes database..."
grep --after-context=1 --no-group-separator '>.* mol:protein' "${ROOT_DIR}/${BASENAME}" >"${ROOT_DIR}/pdb_seqres_filtered.txt"
mv "${ROOT_DIR}/pdb_seqres_filtered.txt" "${ROOT_DIR}/pdb_seqres.txt"

touch "${FLAG_FILE}"
echo "PDB SeqRes database downloaded and processed successfully."
