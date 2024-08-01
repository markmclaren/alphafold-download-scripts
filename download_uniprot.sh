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
ROOT_DIR="${DOWNLOAD_DIR}/uniprot"
TREMBL_URL="https://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_trembl.fasta.gz"
SPROT_URL="https://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz"
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "UniProt database already downloaded and processed."
    exit 0
fi

echo "Downloading UniProt TrEMBL database..."
aria2c --continue=true "${TREMBL_URL}" --dir="${ROOT_DIR}"

echo "Downloading UniProt SwissProt database..."
aria2c --continue=true "${SPROT_URL}" --dir="${ROOT_DIR}"

echo "Unzipping and processing UniProt databases..."
gunzip -f "${ROOT_DIR}"/*.gz
cat "${ROOT_DIR}"/uniprot_sprot.fasta >>"${ROOT_DIR}"/uniprot_trembl.fasta
mv "${ROOT_DIR}"/uniprot_trembl.fasta "${ROOT_DIR}"/uniprot.fasta
rm "${ROOT_DIR}"/uniprot_sprot.fasta

touch "${FLAG_FILE}"
echo "UniProt database downloaded and processed successfully."
