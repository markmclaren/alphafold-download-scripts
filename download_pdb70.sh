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
ROOT_DIR="${DOWNLOAD_DIR}/pdb70"
SOURCE_URL="http://wwwuser.gwdg.de/~compbiol/data/hhsuite/databases/hhsuite_dbs/old-releases/pdb70_from_mmcif_200401.tar.gz"
BASENAME=$(basename "${SOURCE_URL}")
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "PDB70 database already downloaded and processed."
    exit 0
fi

echo "Downloading PDB70 database..."
aria2c "${SOURCE_URL}" --dir="${ROOT_DIR}" --continue=true

echo "Extracting PDB70 database..."
tar --extract --file="${ROOT_DIR}/${BASENAME}" --directory="${ROOT_DIR}"
rm "${ROOT_DIR}/${BASENAME}"

touch "${FLAG_FILE}"
echo "PDB70 database downloaded and processed successfully."
