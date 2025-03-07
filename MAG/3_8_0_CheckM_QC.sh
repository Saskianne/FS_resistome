#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=JGI1
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=metaBAT2_PROKS_MAGs.out
#SBATCH --error=metaBAT2_PROKS_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation

######################
## run checkm
##########################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2
METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2"
CheckM2_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/CheckM2"


for MAG in ${METABAT2_FILEs}/*.metabat2.proksbin; 
do
base=$(basename $MAG .metabat2.proksbin)
if [ ! -f ${CheckM2_OUTPUTs}/]${base}.
sbatch -p base --qos=long --mem=100G -c 16 -t 2-00:00\
     --job-name=checkM2 --output=METABAT2_${base}.out\
     --wrap="checkm2 predict \
     --threads 16 \
     --extension fa \
     --input ${METABAT2_FILES}/*.metabat2.proksbin \
     --output-directory ${CheckM2_OUTPUTs}/"

#
