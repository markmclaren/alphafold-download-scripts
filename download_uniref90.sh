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
ROOT_DIR="${DOWNLOAD_DIR}/uniref90"
SOURCE_URL="https://ftp.ebi.ac.uk/pub/databases/uniprot/uniref/uniref90/uniref90.fasta.gz"
BASENAME=$(basename "${SOURCE_URL}")
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "UniRef90 database already downloaded and processed."
    exit 0
fi

echo "Downloading UniRef90 database..."
aria2c -c "${SOURCE_URL}" --dir="${ROOT_DIR}"

echo "Unzipping UniRef90 database..."
gunzip -f "${ROOT_DIR}/${BASENAME}"

touch "${FLAG_FILE}"
echo "UniRef90 database downloaded and processed successfully."
