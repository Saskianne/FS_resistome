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

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL"
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"

echo "START TIME": '' $(date)
for i in ${ComplORF_Dir}/*.COMPLETE.ORFs.faa ;
do
base=$(basename $i ".COMPLETE.ORFs.faa")
deeparg predict \
    --model LS \
    -i ${ComplORF_Dir}/${base}.COMPLETE.ORFs.faa \
    -o ${DeepARGsDIR}/${base}.deeparg.ORF.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done

# for i in ${ComplORF_Dir}/*.COMPLETE.ORFs.faa ;
# do
# base=$(basename $i ".COMPLETE.ORFs.faa")
# deeparg predict \
#     --model LS \
#     -i ${ComplORF_Dir}/${base}.COMPLETE.CDS.fna \
#     -o ${DeepARGsDIR}/DeepARG_CDS/${base}.deeparg.CDS.out \
#     -d ${DBDIR}/ \
#     --type prot \
#     --min-prob 0.8 \
#     --arg-alignment-identity 50 \
#     --arg-alignment-evalue 1e-10 \
#     --arg-num-alignments-per-entry 1000;
# done


echo "END TIME": '' $(date)
##

## count number of hits
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ORF
wc -l | awk '$1 > 1 {print $1,$2}'
## the total hits
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
awk 'NR > 1' DeepARG_ALL/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# total hits of 634 for all drep MAG
# total hits of

## showing for each file, excluding the header
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
wc -l DeepARG_ALL/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.tsv

# Summary using perl script :
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
for input_file in DeepARG_ALL/*.deeparg.out.mapping.ARG ;
do 
base=$(basename $input_file ".deeparg.out.mapping.ARG")
INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/*.deeparg.out.mapping.ARG"  
OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/deeparg_ALL_summary.tsv"
perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions.pl $input_file DeepARG_ALL_Summary/${base}.deeparg_summary.tsv
done
#


