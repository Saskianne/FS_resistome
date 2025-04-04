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
Canu_Dir="${PacBio_Assembly}/Canu"
Canu_utg_FILES=(${PacBio_Assembly}/Canu/SRR*/*.unitigs.fasta)
Canu_ctg_FILES=(${PacBio_Assembly}/Canu/SRR*/*.contigs.fasta)
Canu_FILES=("${Canu_utg_FILES[@]}" "${Canu_unassem_FILES[@]}")
metaFLYE_FILES=(${PacBio_Assembly}/metaFlye/SRR*/*_assembly.fasta)
wtdbg_FILES=(${PacBio_Assembly}/wtdbg/reRun/*.ctg.fastq)
metaQUAST_DIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/metaQUAST"
wtdbg_noEC_FILES=(${PacBio_Assembly}/wtdbg/*.ctg.fastq)
# Tycycler_FILES=(${PacBio_Assembly}/Trycycler/*/*.fasta)

echo start with metaQUAST
# mkdir PacBio_Assembly/metaQUAST
python /gxfs_work/geomar/smomw681/.conda/envs/PacBio_Assembly/bin/metaquast \
-o ${metaQUAST_DIR}/metaQUAST_reRun -t 4 --conserved-genes-finding ${metaFLYE_FILES[@]} ${wtdbg_FILES[@]} ${wtdbg_noEC_FILES[@]} ${Canu_utg_FILES[@]} ${Canu_ctg_FILES[@]} 
echo metaQUAST done
# rerun with --conserved-genes-finding # BUSCO DB not found and download failed
# TO DO: download BUSCO DB and rerun

echo "END TIME": '' $(date)
##