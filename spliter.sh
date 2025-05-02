#!/bin/bash

echo "starting splitter.sh" 1>&2

# split
INPUT_FILE="combined.csv"
OUTPUT_DIR="partioned"
PREFIX="chunk_"
LINES_PER_FILE=400000

# Extract header
header=$(head -n 1 "$INPUT_FILE")

# Skip header and split the rest
echo "running split" 1>&2
tail -n +2 "$INPUT_FILE" | split -l $LINES_PER_FILE -d --suffix-length=3 --additional-suffix=.csv - "$OUTPUT_DIR/$PREFIX"

echo "adding chunk headers" 1>&2
# Add header to each chunk
for file in "$OUTPUT_DIR"/${PREFIX}*.csv; do
    echo "adding chunk header for $file" 1>&2
    temp_file="${file}.tmp"
    echo "$header" > "$temp_file"
    cat "$file" >> "$temp_file"
    mv "$temp_file" "$file"
done
