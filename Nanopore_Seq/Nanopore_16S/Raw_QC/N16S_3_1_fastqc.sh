#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SED
#SBATCH -t 4-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_3_1_QC.out
#SBATCH --error=N16S_3_1_QC.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate QC_TOOLS

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"
CONCAT_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED"
CONCAT_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/CONCATENATED/16S_Amplicon_Seq_concatenated.fastq"
FILES=($DEMUX_DIR/*/fastq_pass/barcode*/*.fastq)

echo Start QC

mkdir /gxfs_work/geomar/smomw681/NANOPORE_DATA/RAW_QC
RAW_QC_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/RAW_QC"
fastqc --memory 20GB -f fastq -t 8 -noextract -o $RAW_QC_DIR ${FILES[@]}
multiqc -o ${RAW_QC_DIR} -n N16S_FWFWS_RAW_fastqc_summary -i N16S_FWFWS_RAW_fastqc_summary -p  ${RAW_QC_DIR}


echo "END TIME": $(date)

