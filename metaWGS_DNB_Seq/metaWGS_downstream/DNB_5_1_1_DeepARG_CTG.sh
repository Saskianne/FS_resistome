#!/bin/bash
#SBATCH -c 18                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=deepARG
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_5_1_1_dARGs_CTG_ORF.out
#SBATCH --error=DNB_5_1_1_dARGs_CTG_ORF.err
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"
metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
ProdDIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/PRODIGAL"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"
DeepARG_DIR="${metaWGS_SUNWOO_DIR}/DeepARG"
dARG_ORF_DIR="${DeepARG_DIR}/DeepARG_ORF"
dARG_CDS_DIR="${DeepARG_DIR}/DeepARG_CDS"
mkdir -p ${DeepARGsDIR}
mkdir -p ${dARG_ORF_DIR}
mkdir -p ${dARG_CDS_DIR}
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"
cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA

echo "START TIME": '' $(date)
for i in ${ComplORF_Dir}/*.COMPLETE.ORFs.faa ;
do
base=$(basename $i ".COMPLETE.ORFs.faa")
deeparg predict \
    --model LS \
    -i ${ComplORF_Dir}/${base}.COMPLETE.ORFs.faa \
    -o ${DeepARG_DIR}/DeepARG_ORF/${base}.deeparg.ORF.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done

for i in ${ComplCDS_Dir}/*.COMPLETE.CDS.fna ;
do
base=$(basename $i ".COMPLETE.CDS.fna")
deeparg predict \
    --model LS \
    -i ${ComplORF_Dir}/${base}.COMPLETE.CDS.fna \
    -o ${DeepARG_DIR}/DeepARG_CDS/${base}.deeparg.CDS.out \
    -d ${DBDIR}/ \
    --type nucl \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done

echo "END TIME": '' $(date)
##



