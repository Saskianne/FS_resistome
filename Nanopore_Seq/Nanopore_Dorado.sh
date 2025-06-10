#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Dorado_Nanopore1_1.out
#SBATCH --error=Dorado_Nanopore1_1.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

conda activate Dorado_0.9.4
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/Sunwoo_SpongSamples1to4/Samples1to4/20250604_1315_MN34373_FAO38179_7b1a9882/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING"
# /gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado download --model dna_r9.4.1_e8_hac@v3.3
DORADO_MODEL_DIR="/gxfs_work/geomar/smomw681/DORADO/dna_r9.4.1_e8_hac@v3.3"

/gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado basecaller $DORADO_MODEL_DIR/ $RAW_DIR/ --kit-name SQK-RBK004 --trim adapters --device cpu --output-dir $BASECALL_DIR/ --emit-fastq
#\ | /gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado demux --kit-name SQK-RBK004 --output-dir $BASECALL_DIR/ --device cpu --emit-fastq


echo "END TIME": $(date)