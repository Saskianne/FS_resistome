#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BLASTDB
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BLAST_DB_Jutta_ARG1.out
#SBATCH --error=BLAST_DB_Jutta_ARG1.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1

echo "START TIME": $(date)
conda activate BLAST
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLAST_DB

JUTTA_BLAST_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA"
PROKKA_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/PROKKA_JUTTA_STRAIN"
GENOME_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/WGS_JUTTA_STRAIN"
BLAST_DB_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/BLAST_DB"
# Rename the WGS fasta file names as short as possible. 
# If the gene name exceeds certain length, prokka will through an error. 
PROKKA_FILES=${PROKKA_DIR}/*_prokka/*.faa

echo "START TIME": $(date)
echo start BLAST DB making 

echo "Starting BLAST DB making for file: for concatenated .faa file"
makeblastdb -in ${PROKKA_DIR}/J_ARG1_WGS_prokkaCONCAT.faa \
     -dbtype prot \
     -title "J_ARG1_WGS_prokkaCONCAT" \
     -input_type fasta 
     
echo "Finished BLAST DB making for file in ${BLAST_DB_DIR}"

echo end BLAST DB making 
echo "END TIME": $(date)