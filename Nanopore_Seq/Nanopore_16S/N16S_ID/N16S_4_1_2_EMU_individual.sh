#!/bin/bash
#SBATCH -c 16                     # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=EMU
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N16S_4_1_2_EMU.out
#SBATCH --error=N16S_4_1_2_EMU.err
# here starts your actual program call/computation
#
echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate EMU_3.5.4

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
FILTERER_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/NANOPORE_16S_FILTERED"
FILTERED_FILES=($FILTERER_DIR/*.fastq)
EMU_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/EMU/"
echo "START TIME": $(date)
echo Start 16S rRNA identification using EMU

export EMU_DATABASE_DIR=/gxfs_work/geomar/smomw681/DATABASES/EMU_DB
# mkdir /gxfs_work/geomar/smomw681/NANOPORE_DATA/EMU/EMU_N16S_ind 

# Run EMU for each filtered 16S sequecning fastq file
for filt_fastq in ${FILTERED_FILES[@]}; do
    echo processing $filt_fastq file
    emu abundance --db $EMU_DATABASE_DIR --output-dir $EMU_DIR/EMU_N16S_ind --keep-read-assignments --keep-counts --threads 16 $filt_fastq
    echo finished $filt_fastq file
done
echo Finished 16S rRNA identification using EMU
echo "END TIME": $(date)
