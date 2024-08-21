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
ROOT_DIR="${DOWNLOAD_DIR}/uniref30"
SOURCE_URL="https://wwwuser.gwdg.de/~compbiol/uniclust/2023_02/UniRef30_2023_02_hhsuite.tar.gz"
BASENAME=$(basename "${SOURCE_URL}")
FLAG_FILE="${ROOT_DIR}/.download_complete"

mkdir -p "${ROOT_DIR}"

if [ -f "${FLAG_FILE}" ]; then
    echo "UniRef30 database already downloaded and processed."
    exit 0
fi

echo "Downloading UniRef30 database..."
aria2c "${SOURCE_URL}" --dir="${ROOT_DIR}" --continue=true

echo "Extracting UniRef30 database..."
tar --extract --file="${ROOT_DIR}/${BASENAME}" --directory="${ROOT_DIR}"
rm "${ROOT_DIR}/${BASENAME}"

touch "${FLAG_FILE}"
echo "UniRef30 database downloaded and processed successfully."
