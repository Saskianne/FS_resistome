#!/bin/bash
#SBATCH -c 8                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CoverM
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=CoverM_EC_MAG.out
#SBATCH --error=CoverM_EC_MAG.err
#SBATCH --mail-user=slee@geomar.de
#SBATCH --mail-type=ALL
#
# here starts your actual program call/computation
#
########################################
## GENERATE COVERAGE INFORMATION for dereplicated genomes
########################################
## USE CoverM to map raw or error corrected reads to MAGs

echo "START TIME": '' $(date)

# load modules and activate conda environment
cd /gxfs_work/geomar/smomw681/DATA
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

# Set up variables
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/dREP_PROKS_BIN/dereplicated_genomes"
EC_READs="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
CoverM_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CoverM_PROKs"

for sample in `ls ${EC_READs}/*.qc.ec.PE.fq.gz`;
do
base=$(basename $sample ".qc.ec.PE.fq.gz")
coverm genome \
     -t 32 \
     --mapper minimap2-sr \
     --min-read-percent-identity 0.95 \
     --min-read-aligned-percent 0.80 \
     --min-covered-fraction 10 \
     --methods rpkm \
     --interleaved ${EC_READs}/${base}.qc.ec.PE.fq.gz \
     --genome-fasta-extension fa \
     --genome-fasta-directory ${dREP_FILEs}/ \
     --output-file ${CoverM_DIR}/${base}.coverm_proks_dRepMAGs.tsv
done

echo "END TIME": '' $(date)
##