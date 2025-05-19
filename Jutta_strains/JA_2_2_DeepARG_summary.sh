#!/bin/bash

## Summarize DeepARG results by creating a hitmap matrix  
cd /gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/ARG_Analysis_strains
# Define the output file path 
output="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/ARG_Analysis_strains/DeepARG_hitmap_strains_ALL_re.tsv"

# Create a temporary directory for intermediate counts
tmpdir=$(mktemp -d --tmpdir=/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/ARG_Analysis_strains)

# Step 1: Get list of all ARG files
ARG_DIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/DeepARG_strains"
arg_files=("${ARG_DIR}"/*.deeparg.out.mapping.ARG)

# Step 2: Extract all ARG names and store frequency tables
all_args=()

for file in "${arg_files[@]}"; do
    sample=$(basename "$file" .deeparg.out.mapping.ARG)
    tail -n +2 "$file" | cut -f1 | sort | uniq -c | awk -v s="$sample" '{print s"\t"$2"\t"$1}' > "$tmpdir/$sample.count"
    cut -f2 "$tmpdir/$sample.count" >> "$tmpdir/all_args.list"
done

# Step 3: Get unique list of ARGs (sorted)
sort "$tmpdir/all_args.list" | uniq > "$tmpdir/unique_args.txt"
mapfile -t args_array < "$tmpdir/unique_args.txt"

# Step 4: Prepare header
{
    printf "Isolate_Name"
    for arg in "${args_array[@]}"; do
        printf "\t%s" "$arg"
    done
    printf "\n"
} > "$output"

# Step 5: Fill in the hitmap matrix
for file in "${arg_files[@]}"; do
    sample=$(basename "$file" .deeparg.out.mapping.ARG)
    declare -A counts

    while IFS=$'\t' read -r s arg count; do
        counts["$arg"]="$count"
    done < "$tmpdir/$sample.count"

    printf "%s" "$sample"
    for arg in "${args_array[@]}"; do
        printf "\t%d" "${counts[$arg]:-0}"
    done
    printf "\n"
done >> "$output"

# Cleanup
rm -r "$tmpdir"

echo "Hitmap written to $output"
