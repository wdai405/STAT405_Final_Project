#!/bin/bash

echo "Combining output files..."

head -n 1 output/chunk_000_output.csv > final_outputs.csv

for f in output/chunk_*_output.csv; do
    tail -n +2 "$f" >> final_outputs.csv
done

echo "Done."

