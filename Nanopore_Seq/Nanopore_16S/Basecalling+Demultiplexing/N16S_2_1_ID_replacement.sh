#!/bin/bash
#SBATCH -c 20                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SED
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=10G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_2_1_Name_change.out
#SBATCH --error=N16S_2_1_Name_change.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
module load cuda/11.8.0

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ/NANOPORE_16S_Run1/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING/NANOPORE_16S_Run1_BASECALLED"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"
CONCAT_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED"
# DORADO directory: cd /gxfs_work/geomar/smomw681/DORADO

echo Start Changing ID for the 16S run1

# make a concatenated fastq file with new ID
> "/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/16S_Amplicon_Seq_concatenated.fastq"
CONCAT_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/16S_Amplicon_Seq_concatenated.fastq"

# Call the Barcode-sample-Table, rename the ID accordingly and copy it to the file
# replace the ID in the first line of each sequence 
> $CONCAT_FILE
mapfile="/gxfs_work/geomar/smomw681/NANOPORE_DATA/N16S_Run1_barcode_sample_table.txt"
while read -r Run Barcode Sample_ID; do
    echo "Processing $Barcode -> $Sample_ID in run $Run"
    for fastq in "$DEMUX_DIR/$Run/fastq_pass/$Barcode"/*.fastq; do
        [[ ! -e "$fastq" ]] && continue 
        echo "Modifying: $fastq and replace the ID to $Sample_ID"
        awk -v id="$Sample_ID" '
            NR % 4 == 1 {
                match($0, /^@[^ \t]+/);
                rest = substr($0, RLENGTH + 1);
                printf("@%s\t%s\n", id, rest);
                next
            }
            { print }
        ' "$fastq" >> "$CONCAT_FILE"
    done
    echo 
done < <(tail -n +2 "$mapfile")

echo done with Changing ID for the 16S run1

echo "END TIME": $(date)

# mapfile="/gxfs_work/geomar/smomw681/NANOPORE_DATA/N16S_Run1_barcode_sample_table.txt"
# while read -r Barcode Sample_ID; do
#     for barcode in $Barcode; do
#         echo "Processing $barcode -> $Sample_ID"
#     done
# done

sed s\