#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=MMseqs2
#SBATCH -t 6-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N3_3_MMseqs2_contig_metaFLYE_1.out
#SBATCH --error=N3_3_MMseqs2_contig_metaFLYE_1.err
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MMseqs2
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/MMseqs2_NANPORE

echo "START TIME": '' $(date)

## Download the preconstructed database 
mmseqs databases GTDB /gxfs_work/geomar/smomw681/DATABASES/MMseqs2_DB/MMseqs2_GTDB_DB/ /gxfs_work/geomar/smomw681/DATABASES/tmp --force-reuse

MMseqs2_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/MMseqs2_NANPORE"
tmp_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/MMseqs2_NANPORE/tmp"


CONTIG_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/metaFLYE_Nanopore/*/assembly.fasta"
mmseqs easy-taxonomy \
     ${CONTIG_FILE[@]} \
     GTDB \
     taxReport \
     ${tmp_DIR}/${barcodename}_MMseqs2 \
     --threads 16


# for i in /gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/*.fastq ;
# do
#      echo working with $i
#      barcodename=${base#7b1a9882-af73-4933-8538-b8594806f155_}
#      base= $(basename $i .fastq)
#      CONTIGsDir="/gxfs_work/geomar/smomw681/NANOPORE_DATA/metaFLYE_Nanopore/${base}";     
# mmseqs easy-taxonomy \
#      ${CONTIGsDIR}/assembly.fasta \
#      GTDB \
#      $MMseqs2_DIR\
#      $tmp_DIR/${barcodename}_MMseqs2
#     done
echo "END TIME": '' 'date'
##