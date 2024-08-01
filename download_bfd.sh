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
ROOT_DIR="${DOWNLOAD_DIR}/bfd"
SOURCE_URL="https://storage.googleapis.com/alphafold-databases/casp14_versions/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz"
BASENAME=$(basename "${SOURCE_URL}")
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "BFD database already downloaded and processed."
    exit 0
fi

echo "Downloading BFD database..."
aria2c "${SOURCE_URL}" --dir="${ROOT_DIR}"

echo "Extracting BFD database..."
tar --extract --file="${ROOT_DIR}/${BASENAME}" --directory="${ROOT_DIR}"
rm "${ROOT_DIR}/${BASENAME}"

touch "${FLAG_FILE}"
echo "BFD database downloaded and processed successfully."
