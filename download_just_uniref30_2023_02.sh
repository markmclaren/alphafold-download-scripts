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

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

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

# Uniref30
download_database "download_uniref30_2023_02.sh" "uniref30"
