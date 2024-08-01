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

if ! command -v rsync &>/dev/null; then
    echo "Error: rsync could not be found. Please install rsync."
    exit 1
fi

DOWNLOAD_DIR="$1"
ROOT_DIR="${DOWNLOAD_DIR}/pdb_mmcif"
RAW_DIR="${ROOT_DIR}/raw"
MMCIF_DIR="${ROOT_DIR}/mmcif_files"
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}" "${RAW_DIR}" "${MMCIF_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "PDB mmCIF database already downloaded and processed."
    exit 0
fi

echo "Downloading PDB mmCIF files..."
rsync --recursive --links --perms --times --compress --info=progress2 --delete --port=33444 \
    rsync.rcsb.org::ftp_data/structures/divided/mmCIF/ "${RAW_DIR}"

echo "Processing PDB mmCIF files..."
find "${RAW_DIR}/" -type f -iname "*.gz" -exec gunzip {} +
find "${RAW_DIR}" -type f -name "*.cif" -exec mv {} "${MMCIF_DIR}" \;
find "${RAW_DIR}" -type d -empty -delete

echo "Downloading obsolete.dat..."
aria2c "https://files.wwpdb.org/pub/pdb/data/status/obsolete.dat" --dir="${ROOT_DIR}" --allow-overwrite=true

touch "${FLAG_FILE}"
echo "PDB mmCIF database downloaded and processed successfully."
