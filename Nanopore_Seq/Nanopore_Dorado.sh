#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Dorado_Nanopore_sample1to4_1_demux.out
#SBATCH --error=Dorado_Nanopore_sample1to4_1_demux.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

conda activate Dorado_0.9.4
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/Sunwoo_SpongSamples1to4/Samples1to4/20250604_1315_MN34373_FAO38179_7b1a9882/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"

# download the dorado model before running the basecaller (the download via curl might fail due to deprecated model)
# /gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado download --model dna_r9.4.1_e8_hac@v3.3
DORADO_MODEL_DIR="/gxfs_work/geomar/smomw681/DORADO/dna_r9.4.1_e8_hac@v3.3"

# run dorado basecaller and demux
# I ran them separately, but it should be possible to run them in one command as pipe
#echo Start Basecalling
#/gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado basecaller $DORADO_MODEL_DIR/ $RAW_DIR/ --kit-name SQK-RBK004 --trim adapters --device cpu --output-dir $BASECALL_DIR/ >  sample1to4_basecalled.bam 
#echo done with basecalling
echo Start Demultiplexing
/gxfs_work/geomar/smomw681/DORADO/dorado-0.9.5-linux-x64-cuda-11.8/bin/dorado demux $BASECALL_DIR/*.bam --kit-name SQK-RBK004 --output-dir $DEMUX_DIR/ --emit-fastq --threads 16
echo done with demultiplexing

echo "END TIME": $(date)
