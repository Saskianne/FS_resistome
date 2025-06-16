#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=FLYE_N
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N2_2_metaFlye_1.out
#SBATCH --error=N2_2_metaFlye_1.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

metaFLYE_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/metaFLYE_Nanopore"
RAW_READS_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"
FILES=($RAW_READS_DIR/*.fastq)

# iterate over fastq files
for fastq_file in "${FILES[@]}"; do    
     base=$(basename $fastq_file ".fastq")
     mkdir ${metaFLYE_DIR}/${base}
     flye  --nano-raw $fastq_file --out-dir ${metaFLYE_DIR}/${base} -t 12 --meta
done

echo "END TIME": '' $(date)
##