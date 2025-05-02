#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PROD_EXTRACT        # Job name
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Prodigal_Jutta_strain_ALL1.out
#SBATCH --error=Prodigal_Jutta_strain_ALL1.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/GENOME

ProdDIR="/gxfs_work/geomar/smomw681/DATA/GENOME/PRODIGAL_strains"
GENOME_Jutta="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta"
GENOME_Jutta_eurofins="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/Eurofins Genomics Genomes since Sept 2024"

echo "START TIME": '' $(date)

# Iterate prodigal over in-house genomes
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

# # Iterate prodigal over Eurofins geneomes (generated after Sept 2024)
## Do it later when you have access to U drive
# for i in ${GENOME_Jutta_eurofins}/*/*.fasta;
# do
# newfile="$(basename $i .fasta)"
# if [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
#     echo working with $i
#     pprodigal --tasks 2 --chunksize 20000 -p single -m \
#         -i $i \
#         -o ${ProdDIR}/PROD_Temp.gbk \
#         -d ${ProdDIR}/${newfile}.CDS.fna \
#         -a ${ProdDIR}/${newfile}.ORFs.faa
#     echo done with $i
# elif [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
#     echo "File ${ProdDIR}/${newfile}.CDS.fna already exists"
# else 
#     echo "File ${ProdDIR}/${newfile}.CDS.fna does not exist and something went wrong"
# fi
# done


echo "END TIME": '' $(date)

##
