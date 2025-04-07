#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PrkPRK
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=dARG_ASG.out
#SBATCH --error=dARG_ASG.err

# here starts your actual program call/computation

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL

MAG_ASG="/gxfs_work/geomar/smomw681/DATA/MAG_ASG"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/Prodigal_ASG"

echo "START TIME": '' $(date)

# Run prodigal 
echo Start running prodigal at $(date)
for i in ${MAG_ASG}/*.fa ;
do
newfile="$(basename $i .fa)"
if [ ! -f ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 16 --chunksize 20000 -p meta -m \
        -i $i \
        -o ${ProdDIR}/GBK/${newfile}_GBB.gbk \
        -d ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna \
        -a ${ProdDIR}/ORF_ORIGINAL/${newfile}.PROKS.ORF.faa
else 
    echo "File ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna already exists"
fi
done
echo finish with prodigal at $(date)


# Extract the ORFs from the prodigal output
echo Start extracting ORFs at $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

cd /gxfs_work/geomar/smomw681/DATA
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/Prodigal_ASG"

for i in ${ProdDIR}/ORF_ORIGINAL/*.ORF.faa
do
echo working with $i
base=$(basename $i ".PROKS.ORF.faa")
python ${MAG_Files}/SL_Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i ${ProdDIR}/ORF_ORIGINAL/${base}.PROKS.ORF.faa \
     -o ${ProdDIR}/ORF_COMPLETE/${base}.COMPLETE.ORF.faa \
     -r partial=00
done
echo Finished extracting ORFs at $(date)

# Run deepARG
echo start running deepARG at $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/Prodigal_ASG"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/DeepARG_ASG"
DBDIR="/gxfs_work/geomar/smomw681/DATABASES/DeepARG"

echo "START TIME": '' $(date)
for i in ${ComplORF_Dir}/*.COMPLETE.ORF.faa ;
do
base=$(basename $i ".COMPLETE.ORF.faa")
deeparg predict \
    --model LS \
    -i ${ComplORF_Dir}/${base}.COMPLETE.ORF.faa \
    -o ${DeepARGsDIR}/${base}.deeparg.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000;
done

cp ${DeepARGsDIR}/*.deeparg.out.mapping.ARG /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/

echo "END TIME": '' $(date)

##
