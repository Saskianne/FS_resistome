#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PrkPRK
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_2_5_Prodigal.out
#SBATCH --error=DNB_2_5_Prodigal.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
ProdDIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/PRODIGAL"
mkdir -p $ProdDIR
mkdir -p ${ProdDIR}/CDS_ORIGINAL
mkdir -p ${ProdDIR}/ORFs_ORIGINAL

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL

echo "START TIME": '' $(date)
for i in ${PROKS_DIR}/*_ctg_Proks.fna;
do
newfile="$(basename $i _ctg_Proks.fna)"
if [ ! -f ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 16 --chunksize 20000 -p meta -m \
        -i $i \
        -o ${ProdDIR}/GBB_Temp.gbk \
        -d ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna \
        -a ${ProdDIR}/ORFs_ORIGINAL/${newfile}.PROKS.ORFs.faa
else 
    echo "File ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna already exists"
fi
done

echo "END TIME": '' $(date)

##
