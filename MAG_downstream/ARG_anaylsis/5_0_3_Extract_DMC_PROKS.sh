#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExProks
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DMCExctract1_ouputlog_Proks.out
#SBATCH --error=DMCExctract1_errors_Proks.err
# here starts your actual program call/computation

## STEP 6
### EXTRACT CONTIGs FOR THE DIFFERENT CLASSES#
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepMicroClass_ALL
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
OUTPUTDir="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepMicroClass_ALL/PROKS_ALL"
TSVDir="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepMicroClass_ALL"

echo "START TIME": '' $(date)
for i in ${dREP_FILEs}/*.fa;
do
file=$(basename $i ".fa");
if [ ! -f ${OUTPUTDir}/${file}_Proks.fna ]; then
    echo working with $i
    base=$(basename $i ".fa");
    DeepMicroClass extract \
        --fasta $i \
        --class Prokaryote \
        --output ${OUTPUTDir}/${base}_MAG_proks.fna \
        --tsv ${TSVDir}/${base}.fa_pred_onehot_hybrid.tsv; 
else
    echo "File already exists"
fi            
done
echo "END TIME": '' $(date)
##