#!/bin/bash

rm -rf Data
mkdir Data

# URL of the ZIP file
zip_url="https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/CICIDS2017_improved.zip"

# The path where you want to store the ZIP file locally
zip_file="2017data"

# The specific file you want to extract from the ZIP archive
file_to_extract="friday.csv"

# The destination directory where the file will be saved
output_dir="Data/"

# Download the ZIP file using wget (if needed)
wget -O "$zip_file" "$zip_url"

# Extract only the specific file from the ZIP
unzip -j "$zip_file" "$file_to_extract" -d "$output_dir"

# Print the location where the file was saved
echo "File extracted to $output_dir$file_to_extract"


head -n 5 Data/$file_to_extract > sample_data_friday.csv 
