#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dARGS
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=dARGs_Jutta_strains_1.out
#SBATCH --error=dARGs_Jutta_strains_1.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains"
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/DeepARG_strains"
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"
Prod_ORF_COMPLETE="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains/PRODIGAL_COMPLETE/ORF_COMPLETE"


echo "START TIME": '' $(date)
for i in ${Prod_ORF_COMPLETE}/*.COMPLETE.ORFs.faa;
do
base=$(basename $i ".COMPLETE.ORFs.faa")
if [ ! -f ${DeepARGsDIR}/${base}.deeparg.out ]; then
deeparg predict \
    --model LS \
    -i $i \
    -o ${DeepARGsDIR}/${base}.deeparg.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
elif [ -f ${DeepARGsDIR}/${base}.deeparg.out ]; then
    echo "Deeparg file for ${base} already exists"
else 
    echo "Deeparg file for ${base} does not exist and something went wrong"
fi
done

echo "END TIME": '' $(date)
##


### TO DO after the running the script!
# ## count number of hits
# wc -l | awk '$1 > 1 {print $1,$2}'
# ## the total hits
# awk 'NR > 1' DeepARGs/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# ## showing for each file, excluding the header
# wc -l DeepARGs/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.txt


# # DeepARG results for DeepARG run on genome of Jutta's strains 
# cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs
# DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs"
# ORF_ARG_FILEs=(${DeepARGsDIR}/*.deeparg.ORF.out.mapping.ARG)
# cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs
# awk 'NR > 1'  *.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# # total hits of 30 for Juttas stains but output is 31 ????????

# ## showing for each file, excluding the header
# cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs
# wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_BIN_hits_perSample.txt
# # -> same, what???????

# # Summary using perl script :
# cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs
# INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs/*.deeparg.out.mapping.ARG"  
# OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_STRAINs/deeparg_JUTTA_summary.tsv"
# for input_file in *.deeparg.out.mapping.ARG ;
# do 
# base=$(basename $input_file ".deeparg.out.mapping.ARG")
# perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions_modified.pl $input_file ${base}.deeparg_summary.tsv
# done
# #
# ##