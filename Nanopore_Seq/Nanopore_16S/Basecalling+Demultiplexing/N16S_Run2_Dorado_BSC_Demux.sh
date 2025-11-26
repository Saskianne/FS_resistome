#!/bin/bash
#SBATCH -c 20                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_Run2_Dorado_1_fastq.out
#SBATCH --error=N16S_Run2_Dorado_1_fastq.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
module load cuda/11.8.0

conda activate DORADO_1.3.0
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ/NANOPORE_16S_Run2/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING/NANOPORE_16S_Run2_BASECALLED"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/NANOPORE_16S_Run2_DEMUX"

# download the dorado model before running the basecaller (the download via curl might fail due to deprecated model)
# DORADO directory: cd /gxfs_work/geomar/smomw681/DORADO

# dorado download -all
# use:  dna_r10.4.1_e8.2_400bps_hac@v5.2.0
MODEL_DIR="/gxfs_work/geomar/smomw681/DORADO/dna_r10.4.1_e8.2_400bps_hac@v5.2.0"

# run dorado basecaller and demux
# I ran them separately, but it should be possible to run them in one command as pipe
echo Start Basecalling
dorado basecaller $MODEL_DIR/ $RAW_DIR/ --kit-name SQK-16S114-24 --device cpu --emit-fastq --output-dir $DEMUX_DIR/ 
echo done with basecalling

echo "END TIME": $(date)
