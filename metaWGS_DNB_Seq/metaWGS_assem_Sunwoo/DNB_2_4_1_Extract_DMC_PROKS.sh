#!/bin/bash
#SBATCH -c 3                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExProks
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_2_4_1_DMCExctract1_proks.out
#SBATCH --error=DNB_2_4_1_DMCExctract1_proks.err
# here starts your actual program call/computation

## STEP 6
### EXTRACT CONTIGs FOR THE DIFFERENT CLASSES#
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
CTGs_renamed_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/ASSEMBLY/CTGs_renamed"
DMC_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/DeepMicroClass"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
mkdir -p $PROKS_DIR
cd $DMC_DIR

echo "START TIME": '' $(date)
for i in ${CTGs_renamed_DIR}/*_ctg_min500_renamed.fasta;
do
file=$(basename $i "_min500_renamed.fasta");
if [ ! -f ${PROKS_DIR}/${file}_Proks.fna ]; then
    echo working with $i
    base=$(basename $i "_ctg_min500_renamed.fasta");
    DeepMicroClass extract \
        --fasta $i \
        --class Prokaryote \
        --output ${PROKS_DIR}/${base}_ctg_Proks.fna \
        --tsv ${DMC_DIR}/${base}_ctg_min500_renamed.fasta_pred_onehot_hybrid.tsv; 
else
    echo "File already exists"
fi            
done
echo "END TIME": '' $(date)
##