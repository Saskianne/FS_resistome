#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dBGC
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=220G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepBGC_PROKS.out
#SBATCH --error=DeepBGC_PROKS.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepBGC


cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
dREP_PROKS_BIN="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/dREP_PROKS_BIN/dereplicated_genomes"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL"
DeepBGCsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepBGCs/DeepBGC_PROKS"

echo "START TIME": '' $(date)

# Set up variables
FILES=(${dREP_PROKS_BIN}/*.fa)

# Iterate through files in batches of 4
for file in ${dREP_PROKS_BIN}/*.fa ; do
base=$(basename $file ".fa")
deepbgc pipeline \
     --score 0.5  --prodigal-meta-mode \
     --output ${DeepBGCsDIR}/${base}/ \
    $file ; 
done

echo "END TIME": '' $(date)