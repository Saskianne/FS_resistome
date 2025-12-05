#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC
#SBATCH -t 2-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_1_1_QC.out
#SBATCH --error=DNB_1_1_QC.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate QC_TOOLS

cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA
WGS_RAW_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA"
metaWGS_FILES="$WGS_RAW_DIR/BGI_DATA_OCT21_2025/*/*.fq.gz"

echo Start QC

mkdir $WGS_RAW_DIR/DNB_WGS_RAW_QC
RAW_QC_DIR="$WGS_RAW_DIR/DNB_WGS_RAW_QC"
RAW_QC_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/RAW_QC"
fastqc --memory 150GB -f fastq -t 10 -noextract -o $RAW_QC_DIR ${metaWGS_FILES[@]}
multiqc -o ${RAW_QC_DIR} -n FWS_metaWGS_RAW_fastqc_summary -i FWS_metaWGS_RAW_fastqc_summary -p ${RAW_QC_DIR}

echo Finished QC
echo "END TIME": $(date)

