#!/bin/bash
#SBATCH -c 18                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dARGS
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=dARGs_MAG_ORF.out
#SBATCH --error=dARGs_MAG_ORF.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA
ComplORF_FILE="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/PROKKA_JUTTA_STRAIN/J_ARG1_WGS_prokkaCONCAT_with_gene.faa"
DeepARGsDIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/DeepARG_JUTTA_STRAIN"
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"

echo "START TIME": '' $(date)

deeparg predict \
    --model LS \
    -i ${ComplORF_FILE} \
    -o ${DeepARGsDIR}/J_ARG1_WGS_prokkaCONCAT.deeparg.ORF.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done




## count number of hits
cd $DeepARGsDIR
echo ${wc -l | awk '$1 > 1 {print $1,$2}'}
# ## the total hits
# awk 'NR > 1' *.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}' 
# # total hits of 634 for all drep MAG
# # total hits of

# ## showing for each file, excluding the header
# cd $DeepARGsDIR
# wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.tsv

# Summary using perl script :
cd $DeepARGsDIR
for input_file in *.deeparg.out.mapping.ARG ;
do 
base=$(basename $input_file ".deeparg.out.mapping.ARG")
INPUT_FILE="${DeepARGsDIR}/*.deeparg.out.mapping.ARG"  
OUTPUT_FILE="${DeepARGsDIR}/deeparg_ALL_summary.tsv"
perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions.pl $input_file ${base}.deeparg_summary.tsv
done


echo "END TIME": '' $(date)
##