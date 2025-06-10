#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Dorado_Nanopore1.out
#SBATCH --error=Dorado_Nanopore1.err
# here starts your actual program call/computation
#
echo "START TIME": ${date}
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

conda activate Dorado
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/Sunwoo_SpongSamples1to4/Samples1to4/20250604_1315_MN34373_FAO38179_7b1a9882/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING"

dorado basecaller hac $RAW_DIR/ --kit-name SQK-RBK004 --trim all --output-dir $BASECALL_DIR/ \
| dorado demux --kit-name SQK-RBK004 --output-dir $BASECALL_DIR/ 


echo "END TIME": ${date}