#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dBGC
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=220G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepBGC_MAG_ASG.out
#SBATCH --error=DeepBGC_MAG_ASG.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepBGC

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL
DeepBGCsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/DeepBGC_ASG"
MAG_ASG="/gxfs_work/geomar/smomw681/DATA/MAG_ASG"

echo "START TIME": '' $(date)
# Iterate through files in batches of 4
for file in ${MAG_ASG}/*.fa ; do
base=$(basename $file ".fa")
echo working on $base
deepbgc pipeline \
     --score 0.5  --prodigal-meta-mode \
     --output ${DeepBGCsDIR}/${base}/ \
    $file ; 
done

echo "END TIME": '' $(date)