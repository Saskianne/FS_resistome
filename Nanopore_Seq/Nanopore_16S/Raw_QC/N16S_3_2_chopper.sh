#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SED
#SBATCH -t 3-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_3_2_chopper.out
#SBATCH --error=N16S_3_2_chopper.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate CHOPPER_0.12.0

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
CONCAT_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED"
CONCAT_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/16S_Amplicon_Seq_concatenated.fastq"

echo Start Data Filtering 

chopper --quality 12 --minlength 1200 --maxlength 1900 -t 10 -i $CONCAT_FILE \
    > $CONCAT_DIR/N16S_Amplicon_Seq_concat_filtered.fastq

echo "END TIME": $(date)

