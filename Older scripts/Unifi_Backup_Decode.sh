#!/bin/sh
set -e

usage() {
    echo "Usage: $0 <input .unf file> <output .zip file>"
}

if [ -z "$2" || ! -f "$1" ]; then
    usage
    exit 1
fi

INPUT_UNF=$1
OUTPUT_ZIP=$2

TMP_FILE=$(mktemp)
trap "rm -f ${TMP_FILE}" EXIT

openssl enc -d -in "${INPUT_UNF}" -out "${TMP_FILE}" -aes-128-cbc -K 626379616e676b6d6c756f686d617273 -iv 75626e74656e74657270726973656170 -nopad
zip -FF "${TMP_FILE}" --out "${OUTPUT_ZIP}" -y > /dev/null 2>&1