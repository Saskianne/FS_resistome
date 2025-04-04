#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PrkPRK
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Prodigal_ouputlog_DMC_proks.out
#SBATCH --error=Prodigal_errors_DMC_proks.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL

dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL"

echo "START TIME": '' $(date)
for i in ${dREP_FILEs}/*.fa;
do
newfile="$(basename $i .fa)"
if [ ! -f ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 16 --chunksize 20000 -p meta -m \
        -i $i \
        -o ${ProdDIR}/GBB_Temp.gbk \
        -d ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna \
        -a ${ProdDIR}/ORF_ORIGINAL/${newfile}.PROKS.ORFs.faa
else 
    echo "File ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna already exists"
fi
done

echo "END TIME": '' $(date)

##
