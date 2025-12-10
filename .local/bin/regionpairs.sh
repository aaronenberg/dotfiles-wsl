#!/bin/bash

# command to print pki-r config file names
#awk -F',' '{ print "pkir.json,pkir.azure.json," tolower("pkir.azure." $1 ".json") "," tolower("pkir.azure." $1 ".prod" ".json") "," tolower("pkir.azure." $1 ".prod." $3 ".json") "," tolower("pkir.azure." $1 ".prod." $3 ".backup_" $5 ".json") }' ~/regions.csv |  grep -v 'unknown'

JSON_FILE="${1:-./RegionMap.json}"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Build a mapping of RegionName -> ShortCode
declare -A region_shortcodes
while IFS=$'\t' read -r name code; do
    region_shortcodes["${name}"]="${code}"
done < <(jq -r '.Regions[] | [.RegionName, .ShortCode] | @tsv' "${JSON_FILE}")

echo "CLOUD,NAME,CODE,PAIR,PAIR CODE"
jq -r '.Regions[] | [.AzureEnvironment, .RegionName, .ShortCode, .RegionPair] | @tsv' "${JSON_FILE}" | while IFS=$'\t' read -r cloud name code pair; do
    if [[ -n ${pair} ]]; then
        pair_code="${region_shortcodes[$pair]}"
    else
        pair="Unknown"
        pair_code="Unknown"
    fi
    echo "${cloud},${name},${code},${pair},${pair_code}"
done
