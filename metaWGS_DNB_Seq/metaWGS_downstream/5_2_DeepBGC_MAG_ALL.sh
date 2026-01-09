#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dBGC
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=220G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepBGC_MAG_ALL.out
#SBATCH --error=DeepBGC_MAG_ALL.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepBGC


cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
DeepBGCsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepBGC_ALL"

echo "START TIME": '' $(date)

# Set up variables
FILES=(${dREP_FILEs}/*.fa)

# Iterate through files in batches of 4
for file in ${dREP_FILEs}/*.fa ; do
base=$(basename $file ".fa")
deepbgc pipeline \
     --score 0.5  --prodigal-meta-mode \
     --output ${DeepBGCsDIR}/${base}/ \
    $file ; 
done

echo "END TIME": '' $(date)