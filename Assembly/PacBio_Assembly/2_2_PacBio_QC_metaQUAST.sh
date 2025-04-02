#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=METAQUAST          # Job name
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_metaquast.out
#SBATCH --error=PacBio_metaquast.err

# Run MetaQUAST for PacBio assembly QC
# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly
# module load parallel/20230822
# module load gnuplot/5.4.9

echo "START TIME": '' $(date)

# Set up variables
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
RAW_FILES=(${PacBio_RAW}/SRR*.fastq.gz)
PacBio_Assembly="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly"
Canu_FILES=(${PacBio_Assembly}/Canu/SRR*/*.contigs.fasta)
metaFLYE_FILES=(${PacBio_Assembly}/metaFlye/*/*assembly.fasta)
wtdbg_FILES=(${PacBio_Assembly}/wtdbg/reRun/*.ctg.fastq)
metaQUAST_DIR="${PacBio_Assembly}/metaQUAST"
# Tycycler_FILES=(${PacBio_Assembly}/Trycycler/*/*.fasta)

## general usage of metaQUAST
# python metaquast.py contigs_1 contigs_2 ... \
# -r reference_1,reference_2,reference_3,...

echo start with metaQUAST
# mkdir PacBio_Assembly/metaQUAST
python /gxfs_work/geomar/smomw681/.conda/envs/PacBio_Assembly/bin/metaquast \
-o $metaQUAST_DIR -t 4 --pacbio ${RAW_FILES[@]} ${Canu_FILES[@]} ${metaFLYE_FILES[@]} ${wtdbg_FILES[@]} 



 echo "END TIME": '' $(date)