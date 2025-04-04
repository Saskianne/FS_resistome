#!/bin/bash
#SBATCH -c 18                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dARGS
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=dARGs_Jutta_strains.out
#SBATCH --error=dARGs_Jutta_strains.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL"
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"

echo "START TIME": '' $(date)
for i in ${ComplORF_Dir}/*.COMPLETE.ORFs.faa;
do
base=$(basename $i ".COMPLETE.ORFs.faa")
deeparg predict \
    --model LS \
    -i ${ComplORF_Dir}/${base}.COMPLETE.ORFs.faa \
    -o ${DeepARGsDIR}/${base}.deeparg.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done

echo "END TIME": '' $(date)
##

# ## count number of hits
# wc -l | awk '$1 > 1 {print $1,$2}'
# ## the total hits
# awk 'NR > 1' DeepARGs/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# ## showing for each file, excluding the header
# wc -l DeepARGs/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.txt

## Summary using perl script :
# INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARGs_hits_perSample.txt"  
# OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/deeparg_ALL_summary.txt"
# perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_summarize_deeparg.pl "$INPUT_FILE" "$OUTPUT_FILE"
##