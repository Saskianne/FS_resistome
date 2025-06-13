#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PROKKA_JUTTA
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PROKKA_Jutta_ARG1.out
#SBATCH --error=PROKKA_Jutta_ARG1.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1

echo "START TIME": $(date)
conda activate PROKKA
cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA

PROKKA_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/PROKKA_JUTTA_STRAIN"
GENOME_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/WGS_JUTTA_STRAIN"
# Rename the WGS fasta file names as short as possible. 
# If the gene name exceeds certain length, prokka will through an error. 
GENOME_FILES=${GENOME_DIR}/*.fasta

echo "START TIME": $(date)
echo start prokka
for file in ${GENOME_FILES}
do 
base=$(basename "$file" .fasta)
echo "Starting prokka for file: $base"

prokka --kingdom Bacteria --quiet --outdir ${PROKKA_DIR} --prefix J_ARG1 --cpus 8 --locustag ${base} ${GENOME_FILES}

echo "Finished prokka for file: $base"
done

echo end prokka
echo "END TIME": $(date)