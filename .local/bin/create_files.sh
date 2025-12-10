#!/bin/bash

INPUT_FILE="${1}"

# Check if the input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Input file '$INPUT_FILE' not found."
    exit 1
fi

# Read the input file line by line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Split the line by commas
    IFS=',' read -ra files <<< "$line"
    for file in "${files[@]}"; do
        # Trim leading/trailing whitespace
        file=$(echo "$file" | xargs)
        if [[ -z "$file" ]]; then
            continue
        fi
        if [[ ! -e "$file" ]]; then
            echo "{}" > "$file"
            echo "Created: $file"
        else
            echo "Exists: $file"
        fi
    done
done < "$INPUT_FILE"
