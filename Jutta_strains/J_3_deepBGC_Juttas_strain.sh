#!/bin/bash
#SBATCH -c 4                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dBGC
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepBGC_J_strains_bacthmode0.out
#SBATCH --error=DeepBGC_J_strains_bacthmode0.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG


cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
GENOME_Jutta="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/GENOME_Jutta"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/STRAINs_PRODIGAL"
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs"
DeepBGCsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepBGCs"

echo "START TIME": '' $(date)

# Set up variables
FILES=(${GENOME_Jutta}/*.fasta)

# Iterate through files in batches of 4
for file in ${GENOME_Jutta}/*.fasta ; do
base=$(basename $file ".fasta")
newfile="$(basename $file .fasta)"
deepbgc pipeline \
     --score 0.5 \
     --prodigal-single-mode \
     --output ${DeepBGCsDIR}/${base}/ \
    $file ; 
done

echo "END TIME": '' $(date)