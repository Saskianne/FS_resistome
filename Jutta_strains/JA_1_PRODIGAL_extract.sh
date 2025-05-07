#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PROD_EXTRACT        # Job name
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Prodigal_Jutta_strain_ALL2.out
#SBATCH --error=Prodigal_Jutta_strain_ALL2.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/GENOME_Jutta

ProdDIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains"
GENOME_Jutta="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta"
GENOME_Jutta_eurofins="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/GENOMEs_Eurofins"

echo "START TIME": '' $(date)

##DONE
## TEST: Iterate pprodigal over in-house genomes 
# for i in ${GENOME_Jutta}/*.fasta;
# do
# newfile="$(basename $i '.fasta')"
# if [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
#     echo working with $i
#     pprodigal --tasks 6 --chunksize 20000 \
#         -p single -m \
#         -i $i \
#         -o ${ProdDIR}/PROD_Temp.gbk \
#         -d ${ProdDIR}/${newfile}.CDS.fna \
#         -a ${ProdDIR}/${newfile}.ORFs.faa 
#     echo done with $i
# elif [ -f ${ProdDIR}/${newfile}.CDS.fna ]; then
#     echo "File ${ProdDIR}/${newfile}.CDS.fna already exists"
# else 
#     echo "File ${ProdDIR}/${newfile}.CDS.fna does not exist and something went wrong"
# fi
# done

# # DONE
# # Iterate pprodigal over in-house genomes
# for i in ${GENOME_Jutta}/GENOMEs_else/*.fasta;
# do
# newfile="$(basename $i '.fasta')"
# if [ ! -f ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna ]; then
#     echo working with $i
#     pprodigal --tasks 6 --chunksize 20000 \
#         -p single -m \
#         -i $i \
#         -o ${ProdDIR}/Prodigal_InHouse/${newfile}_prodigal.gbk \
#         -d ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna \
#         -a ${ProdDIR}/Prodigal_InHouse/${newfile}.ORFs.faa 
#     echo done with $i
# elif [ -f ${ProdDIR}/${newfile}.CDS.fna ]; then
#     echo "File ${ProdDIR}/${newfile}.CDS.fna already exists"
# else 
#     echo "File ${ProdDIR}/${newfile}.CDS.fna does not exist and something went wrong"
# fi
# done

# DONE
# Iterate prodigal over Eurofins geneomes (generated after Sept 2024)
# Do it later when you have access to U drive
for i in ${GENOME_Jutta_eurofins}/*/*.fasta;
do
newfile="$(basename $i .fasta)"
if [ ! -f ${ProdDIR}/PRODIGAL_Eurofins/${newfile}.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 2 --chunksize 20000 -p single -m \
        -i $i \
        -o ${ProdDIR}/PRODIGAL_Eurofins/${newfile}_prodigal.gbk \
        -d ${ProdDIR}/PRODIGAL_Eurofins/${newfile}.CDS.fna \
        -a ${ProdDIR}/PRODIGAL_Eurofins/${newfile}.ORFs.faa
    echo done with $i
elif [ ! -f ${ProdDIR}/${newfile}.CDS.fna ]; then
    echo "File ${ProdDIR}/${newfile}.CDS.fna already exists"
else 
    echo "File ${ProdDIR}/${newfile}.CDS.fna does not exist and something went wrong"
fi
done

# ## DONE
# # RERUN of genomefiles with space in the name: Iterate pprodigal over in-house genomes
# # The prodigal output files are placed in the eurofin directory for convenience
# for i in ${GENOME_Jutta}/GENOMEs_else/Names_should_be_fixed/*.fasta;
# do
# newfile="$(basename $i '.fasta')"
# if [ ! -f ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna ]; then
#     echo working with $i
#     pprodigal --tasks 6 --chunksize 20000 \
#         -p single -m \
#         -i $i \
#         -o ${ProdDIR}/PRODIGAL_Eurofins/${newfile}_prodigal.gbk \
#         -d ${ProdDIR}/PRODIGAL_Eurofins/${newfile}.CDS.fna \
#         -a ${ProdDIR}/PRODIGAL_Eurofins/${newfile}.ORFs.faa 
#     echo done with $i
# elif [ -f ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna ]; then
#     echo "File ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna already exists"
# else 
#     echo "File ${ProdDIR}/Prodigal_InHouse/${newfile}.CDS.fna does not exist and something went wrong"
# fi
# done

conda activate Assembly
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"

echo Starting with CDS and ORF exraction at $(date)

ProdDIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains"
Prod_Test_COMP="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains/PRODIGAL_Test_COMPLETE"

##DONE
# echo CDS and ORF extraction of TEST strains 
# # Iterate over prodigal output files of TEST strains
# for i in ${ProdDIR}/*.CDS.fna
# do
# echo working with $i
# base=$(basename $i ".CDS.fna")
# python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
#      -i $i \
#      -o ${Prod_Test_COMP}/${base}.COMPLETE.CDS.fna \
#      -r partial=00
# done

# for i in ${ProdDIR}/*.ORFs.faa
# do
# echo working with $i
# base=$(basename $i ".ORFs.faa")
# python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
#      -i ${ProdDIR}/${base}.ORFs.faa \
#      -o ${Prod_Test_COMP}/${base}.COMPLETE.ORFs.faa \
#      -r partial=00
# done

# echo Copying complete CDS and ORF of TEST strains to the final directory
Prod_CDS_COMPLETE="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains/PRODIGAL_COMPLETE/CDS_COMPLETE"
Prod_ORF_COMPLETE="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/PRODIGAL_strains/PRODIGAL_COMPLETE/ORF_COMPLETE"

# cp ${Prod_Test_COMP}/*.COMPLETE.CDS.fna  ${Prod_CDS_COMPLETE}/
# cp ${Prod_Test_COMP}/*.COMPLETE.ORFs.faa ${Prod_ORF_COMPLETE}/

# TO-DO
echo CDS and ORF extraction of In-House strains at $(date) 
# Iterate over prodigal output files of In-House sequencing strains (strais sequenced before Sept 2024)
# for i in ${ProdDIR}/Prodigal_InHouse/*.CDS.fna
# do
# echo working with $i
# base=$(basename $i ".CDS.fna")
# python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
#      -i ${ProdDIR}/Prodigal_InHouse/${base}.CDS.fna \
#      -o ${Prod_CDS_COMPLETE}/${base}.COMPLETE.CDS.fna \
#      -r partial=00
# done

# for i in ${ProdDIR}/*.ORFs.faa
# do
# echo working with $i
# base=$(basename $i ".ORFs.faa")
# python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
#      -i ${ProdDIR}/Prodigal_InHouse/${base}.ORFs.faa \
#      -o ${Prod_ORF_COMPLETE}/${base}.COMPLETE.ORFs.faa \
#      -r partial=00
# done


#DONE
# Iterate over prodigal output files of Eurofins Genomics sequencing strains (strais sequenced after Sept 2024)
for i in ${ProdDIR}/PRODIGAL_Eurofins/*.CDS.fna
do
echo working with $i
base=$(basename $i ".CDS.fna")
python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i ${ProdDIR}/PRODIGAL_Eurofins/${base}.CDS.fna \
     -o ${Prod_CDS_COMPLETE}/${base}.COMPLETE.CDS.fna \
     -r partial=00
done

for i in ${ProdDIR}/PRODIGAL_Eurofins/*.ORFs.faa
do
echo working with $i
base=$(basename $i ".ORFs.faa")
python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i ${ProdDIR}/PRODIGAL_Eurofins/${base}.ORFs.faa \
     -o ${Prod_ORF_COMPLETE}/${base}.COMPLETE.ORFs.faa \
     -r partial=00
done


echo "END TIME": '' $(date)

##
