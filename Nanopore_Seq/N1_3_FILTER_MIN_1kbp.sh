#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Flt_N
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=15G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N1_3_Filt_min_750bp.out
#SBATCH --error=N1_3_Filt_min_750bp.err
# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/DEMUX_FILTERED_min1kbp
MIN1kbp_CONTIGs="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/DEMUX_FILTERED_min1kbp/DEMUX_min1kbp_new"
DEMUX_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED"

echo "START TIME": '' $(date)
for i in ${DEMUX_DIR}/*.fastq; do
     base=$(basename $i .fastq)
     barcodename=${base#7b1a9882-af73-4933-8538-b8594806f155_}
     newfile="${barcodename}_min1kbp.fastq"
     if [ ! -f ${MIN1kbp_CONTIGs}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/NANOPORE_DATA/NANOPORE_SCRIPTs/SL_filter_contigs_on_minbp_FASTQ.pl $i 1000
     else
          echo "File already exists"
     fi
done
echo "END TIME": '' $(date)
##