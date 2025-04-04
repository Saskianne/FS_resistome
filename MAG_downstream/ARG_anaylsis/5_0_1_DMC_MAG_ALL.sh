#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DMC
#SBATCH -t 6-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepMicroClass_1.out
#SBATCH --error=DeepMicroClass_1.err
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepMicroClass_ALL

echo "START TIME": '' $(date)

dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
DMC_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepMicroClass_ALL"

for i in /gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes/*.fa;
do
echo working with $i; 
base=$(basename $i ".fa");
DeepMicroClass predict \
     --input $i \
     --output_dir ${DMC_DIR}/ \
     --encoding onehot \
     --mode hybrid \
     --device cpu; 
    done
echo "END TIME": '' 'date'
##