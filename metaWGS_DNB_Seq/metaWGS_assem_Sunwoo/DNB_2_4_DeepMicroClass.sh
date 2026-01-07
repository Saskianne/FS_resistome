#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DMC
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_2_4_DMC.out
#SBATCH --error=DNB_2_4_DMC.err
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
CTGs_renamed_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/ASSEMBLY/CTGs_renamed"
DMC_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/DeepMicroClass"
mkdir -p $DMC_DIR

cd $DMC_DIR

echo "START TIME": '' $(date)

for i in ${CTGs_renamed_DIR}/*_ctg_min500_renamed.fasta; do
    echo working with $i 
    DeepMicroClass predict \
        --input $i \
        --output_dir ${DMC_DIR}/ \
        --encoding onehot \
        --mode hybrid \
        --device cpu
done

echo "END TIME": '' 'date'
##