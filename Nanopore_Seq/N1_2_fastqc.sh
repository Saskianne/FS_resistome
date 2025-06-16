#!/bin/bash
#SBATCH -c 8                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_dorado
#SBATCH -t 12:00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p interactive                     # Partition to submit to
#SBATCH --mem=10G                  # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Nanopore_fastqc_1.out
#SBATCH --error=Nanopore_fastqc_1.err

# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"
QC_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/QC_NANOPORE"


# # Run FastQC on Raw Nanopore reads
# fastqc --memory 10GB -f fastq -t 4 -noextract -o ${QC_DIR} ${BASECALL_DIR}/calls_2025-06-10_T13-56-31.fastq

# # Run FastQC on Demultiplexed Nanopore reads
# FILES=${DEMUX_DIR}/*fastq
# fastqc --memory 10GB -f fastq -t 4 -noextract -o ${QC_DIR} ${FILES[@]} 
# multiqc -o ${QC_DIR} -n Sample1to4_dorado_fastqc_summary -i Sample1to4_dorado_fastqc_summary -p  ${QC_DIR}   

DEMUX_DIR_min1kb="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/DEMUX_FILTERED_min1kbp"
FASTQC_DIR_min1kbp="/gxfs_work/geomar/smomw681/NANOPORE_DATA/QC_NANOPORE/FASTQC_Nanopore_min1kbp"
FILTERED_FILES=${DEMUX_DIR_min1kb}/*fastq
fastqc --memory 10GB -f fastq -t 4 -noextract -o ${FASTQC_DIR_min1kbp} ${FILTERED_FILESS[@]} 
multiqc -o ${FASTQC_DIR_min1kbp} -n Sample1to4_dorado_fastqc_summary -i Sample1to4_dorado_fastqc_summary -p  ${FASTQC_DIR_min1kbp}   


echo "END TIME": '' $(date)
###