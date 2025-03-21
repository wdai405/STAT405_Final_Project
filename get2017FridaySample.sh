#!/bin/bash


# URL of the 2017 ZIP file
zip_url="https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/CICIDS2017_improved.zip"

# local file name for the downloaded ZIP
zip_file="2017data.zip"

# The specific file you want to extract from the ZIP archive
file_to_extract="friday.csv"



# Download the ZIP file using wget
wget -O "$zip_file" "$zip_url"  # -O specifies the output file name

# Extract only the specific file from the ZIP
unzip -j "$zip_file" "$file_to_extract"  # -j extract without keeping ZIP's file structure



head $file_to_extract > friday2017_sample.csv
rm ${zip_file} ${file_to_extract}

echo "downloaded 2017 ZIP; extracted friday.csv; saved the head of friday.csv as a sample; removed large 2017ZIP and friday.csv"
