#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC
#SBATCH -t 4-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_3_2_QC.out
#SBATCH --error=N16S_3_2_QC.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate QC_TOOLS

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"

echo Start QC

# mkdir /gxfs_work/geomar/smomw681/NANOPORE_DATA/RAW_QC
QC_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/QC_NANOPORE"
RAW_FILES=($DEMUX_DIR/NANOPORE_16S_RENAMED/*.fastq)
fastqc --memory 50GB -f fastq -t 8 -noextract -o $QC_DIR/QC_NANOPORE_16S_RAW ${RAW_FILES[@]}
multiqc -o $QC_DIR/QC_NANOPORE_16S_RAW -n N16S_FWFWS_RAW_fastqc_summary -i N16S_FWFWS_RAW_fastqc_summary -p  $QC_DIR/QC_NANOPORE_16S_RAW

FILTERED_FILES=($DEMUX_DIR/NANOPORE_16S_FILTERED/*.fastq)
fastqc --memory 50GB -f fastq -t 8 -noextract -o $QC_DIR/QC_NANOPORE_16S_FILTERED ${FILTERED_FILES[@]}
multiqc -o $QC_DIR/QC_NANOPORE_16S_FILTERED -n N16S_FWFWS_FILT_fastqc_summary -i N16S_FWFWS_FILT_fastqc_summary -p  $QC_DIR/QC_NANOPORE_16S_FILTERED


echo "END TIME": $(date)

