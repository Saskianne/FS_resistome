#!/bin/bash
#SBATCH -c 4                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DORADO
#SBATCH -t 2-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=10G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_2_Trim.out
#SBATCH --error=N16S_2_Trim.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
module load cuda/11.8.0

conda activate DORADO_1.3.0
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ
RAW_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/16S_AMPLICON_SEQ/NANOPORE_16S_Run1/pod5"
BASECALL_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/BASECALLING/NANOPORE_16S_Run1_BASECALLED"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"

# download the dorado model before running the basecaller (the download via curl might fail due to deprecated model)
# DORADO directory: cd /gxfs_work/geomar/smomw681/DORADO



# run dorado basecaller and demux
# I ran them separately, but it should be possible to run them in one command as pipe
echo Start Trimming
for fastq in $DEMUX_DIR/NANOPORE_16S_Run1_DEMUX/fastq_pass/*/*.fastq; do 
    dorado trim $fastq --sequencing-kit SQK-16S114-24 --emit-fastq --no-trim-primers
    echo done with trimming $fastq
done
for fastq in $DEMUX_DIR/NANOPORE_16S_Run2_DEMUX/BioC101/20251027_1216_MN34373_FBD63316_2014e4b1/fastq_pass/*/*.fastq; do 
    dorado trim $fastq --sequencing-kit SQK-16S114-24 --emit-fastq --no-trim-primers
    echo done with trimming $fastq
done

echo "END TIME": $(date)
