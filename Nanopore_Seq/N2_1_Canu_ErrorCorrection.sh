#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CANU_EC
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N2_1_Canu_EC_1.out
#SBATCH --error=N2_1_Canu_EC_1.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
# module parallel/20230822

conda activate PacBio_Assembly
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/CANU_NANOPORE
DEMUX_DIR_min1kb="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/DEMUX_FILTERED_min1kbp"
CANU_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CANU_NANOPORE"


# FILES=($DEMUX_DIR/*.fastq)
# cat FILES | parallel -j 4 "base=$(basename -s {} "7b1a9882-af73-4933-8538-b8594806f155_") ; \
#     canu  -p ${base} -d ${CANU_DIR}/${base} minMemory=20 minThreads=8 \
#     genomeSize=7m -nanopore ${DEMUX_DIR}/*.fastq"

# iterate over fastq files
for file in ${DEMUX_DIR_min1kb}/*.fastq
    do 
    base=$(basename $file .fastq)
    barcodename=${base#7b1a9882-af73-4933-8538-b8594806f155_}
    canu -correct -p ${barcodename} -d ${CANU_DIR}/${barcodename} minMemory=20 minThreads=8 \
    genomeSize=7m -nanopore-raw $file
done

echo "END TIME": $(date)
