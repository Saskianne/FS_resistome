#!/bin/bash
#SBATCH -c 4                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PROD_Str
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Prodigal_Jutta_strain.out
#SBATCH --error=Prodigal_Jutta_strain.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL

ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/STRAINs_PRODIGAL"
GENOME_Jutta="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/GENOME_Jutta"

echo "START TIME": '' $(date)
for i in ${GENOME_Jutta}/*.fasta;
do
newfile="$(basename $i .fasta)"
if [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 2 --chunksize 20000 -p single -m \
        -i $i \
        -o ${ProdDIR}/PROD_Temp.gbk \
        -d ${ProdDIR}/${newfile}.CDS.fna \
        -a ${ProdDIR}/${newfile}.ORFs.faa
    echo done with $i
elif [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
    echo "File ${ProdDIR}/${newfile}.CDS.fna already exists"
else 
    echo "File ${ProdDIR}/${newfile}.CDS.fna does not exist and something went wrong"
fi
done

echo "END TIME": '' $(date)

##
