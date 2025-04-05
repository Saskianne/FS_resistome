#!/bin/bash
#SBATCH -c 6                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=extract_CDS_ORF
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Extract_CDS_ORF_MAG.out
#SBATCH --error=Extract_CDS_ORF_MAG.err

##
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL"


echo "START TIME": '' $(date)

for i in ${ProdDIR}/CDS_ORIGINAL/*.CDS.fna
do
echo working with $i
base=$(basename $i ".CDS.fna")
python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i $i \
     -o ${ProdDIR}/CDS_COMPLETE/${base}.COMPLETE.CDS.fna \
     -r partial=00
done

for i in ${ProdDIR}/ORF_ORIGINAL/*.ORFs.faa
do
echo working with $i
base=$(basename $i ".ORFs.faa")
python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i $i \
     -o ${ProdDIR}/ORF_COMPLETE/${base}.COMPLETE.ORFs.faa \
     -r partial=00
done

echo "END TIME": '' $(date)
##