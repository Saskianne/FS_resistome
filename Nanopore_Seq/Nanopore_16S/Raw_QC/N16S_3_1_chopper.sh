#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SED
#SBATCH -t 3-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_3_1_chopper.out
#SBATCH --error=N16S_3_1_chopper.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate CHOPPER_0.12.0

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
RENAMED_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/NANOPORE_16S_RENAMED"
FILTERED_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/NANOPORE_16S_FILTERED"
CONCAT_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED"
CONCAT_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/N16S_Seq_concat_filt.fastq"
FILES=$RENAMED_DIR/*.fastq
echo Start Data Filtering 

for fastq  in ${FILES[@]}; do
    echo "Filtering $fastq"
    chopper --quality 12 --minlength 1200 --maxlength 1900 -t 10 -i $fastq \
        > "$FILTERED_DIR/$(basename $fastq .fastq)_filt.fastq"
    echo "done filtering $fastq"
done

echo "Concatenating filtered files"
> $CONCAT_FILE
for fastq in $RENAMED_DIR/*.fastq; do
    cat $fastq >> $CONCAT_FILE
done
echo "done concatenation"

echo "END TIME": $(date)

