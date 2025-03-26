#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=AntSMASH
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=AntiSMASH_Jutta_strains.out
#SBATCH --error=AntiSMASH_Jutta_strains.err
#
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate AntiSMASH

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/AntiSMASH_PROKS

echo "START TIME": '' $(date)

# Set up variables
GENOME_Jutta="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/GENOME_Jutta"
DBDIR="/gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases"
ANTISMASH_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/AntiSMASH_PROKS"
FILES=($GENOME_Jutta/*.fasta)

for file in ${GENOME_Jutta}/*.fasta; do
base=$(basename $file ".fasta")
sbatch --cpus-per-task=4 --mem=100G --wrap="antismash \
     -t bacteria \
     --cpus 8 \
     --databases ${DBDIR}/ \
     --output-dir ${ANTISMASH_DIR}/${base}/ \
     --output-basename ${base} \
     --genefinding-tool prodigal \
     $file"
done


echo "END TIME": '' $(date)
#
