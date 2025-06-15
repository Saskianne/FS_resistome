#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BLASTX
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BLASTx_Jutta_ARG1_2.out
#SBATCH --error=BLASTx_Jutta_ARG1_2.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1

echo "START TIME": $(date)
conda activate BLAST
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLAST_DB

JUTTA_BLAST_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA"
BLAST_DB_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLAST_DB"

echo "START TIME": $(date)
echo start BLAST

echo Start with blastx for the created database
blastx \
    -outfmt 7 \
    -query ${JUTTA_BLAST_DIR}/CONCATENATED_nt_FILE_PCRs.fasta \
    -lcase_masking \
    -max_hsps 20 \
    -max_target_seqs 15 \
    -db J_ARG1_WGS_prokkaCONCAT.faa \
    -out ${JUTTA_BLAST_DIR}/BLASTX_J_ARG1_WGS_PCR_HIT_tab7.txt \
    -sorthits 4 \
    -sorthsps 4
echo Finished blastx for the created database and stored in the ${BLAST_DB_DIR} 

echo end BLAST
echo "END TIME": $(date)