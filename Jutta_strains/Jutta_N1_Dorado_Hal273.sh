#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Dorado_Nanopore1_hal273.out
#SBATCH --error=Dorado_Nanopore1_hal273.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

conda activate Dorado_0.9.4
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
RAW_DIR="/gxfs_work/geomar/smomw681/JUTTA_GENOME_RAW/Genomdaten_Pseudoalteromonas\ sp.\ Hal273/Hal273/Hal273/Hal273/20220118_1311_MN34373_AIZ124_5caa0bff/fast5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING"
# /gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado download --model dna_r9.4.1_e8_hac@v3.3
DORADO_MODEL_DIR="/gxfs_work/geomar/smomw681/DORADO/dna_r9.4.1_e8_hac@v3.3"

/gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado basecaller $DORADO_MODEL_DIR/ \
    "/gxfs_work/geomar/smomw681/JUTTA_GENOME_RAW/Genomdaten_Pseudoalteromonas sp. Hal273/Hal273/Hal273/Hal273/20220118_1311_MN34373_AIZ124_5caa0bff/fast5/" \
     --device cpu --kit-name SQK-RAD004 --trim all --output-dir $BASECALL_DIR/ --emit-fastq 


echo "END TIME": $(date)