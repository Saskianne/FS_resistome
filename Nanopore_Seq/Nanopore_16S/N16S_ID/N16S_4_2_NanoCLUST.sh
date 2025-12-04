#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=NanoCLUST
#SBATCH -t 3-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_4_2_Nanoclust.out
#SBATCH --error=N16S_4_2_Nanoclust.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
module load singularity/3.11.5
conda activate NanoCLUST

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
CONCAT_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED"
CONCAT_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/N16S_Amplicon_Seq_concat_filtered.fastq"
NANOCLUST_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/NanoCLUST"
DB_DIR="/gxfs_work/geomar/smomw681/DATABASES/NCBI_16S_DB"
TaxDB_DIR="/gxfs_work/geomar/smomw681/DATABASES/NCBI_16S_DB/TAX_DB"

echo Start 16S rRNA identification using EMU

# mkdir /gxfs_work/geomar/smomw681/NANOPORE_DATA/NanoCLUST
nextflow run $NANOCLUST_DIR/main.nf \ 
             -profile singularity \ 
             --reads $CONCAT_FILE \ 
             --db $DB_DIR \ 
             --tax $TaxDB_DIR

echo Finished 16S rRNA identification using EMU
echo "END TIME": $(date)
