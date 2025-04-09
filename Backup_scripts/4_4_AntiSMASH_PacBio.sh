#!/bin/bash
#SBATCH -c 18                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=AntSMASH
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=AntiSMASH_MAG_PacBio.out
#SBATCH --error=AntiSMASH_MAG_PacBio.err
#
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate AntiSMASH

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/

echo "START TIME": '' $(date)

# Set up variables
MAG_metaFlye="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye"
DBDIR="/gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases"
ANTISMASH_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/AntiSMASH_PacBio"

for file in ${MAG_metaFlye}/*.fa; do
base=$(basename $file ".fa")
echo working with $file
sbatch --cpus-per-task=4 --mem=100G --wrap="antismash \
     -t bacteria \
     --cpus 8 \
     --databases ${DBDIR}/ \
     --output-dir ${ANTISMASH_DIR}/${base}/ \
     --html-title ${base}_antiSMASH \
     --output-basename ${base} \
     --genefinding-tool prodigal-m \
     $file"
done


echo "END TIME": '' $(date)
#
## Summary antiSMAH results
## 
# python /gxfs_work/geomar/smomw647/ComGenomicsTools/multismash/workflow/scripts/count_regions.py \
#      /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/AntiSMASH_PROKS/ \
#      AntiSMASH_PROKS_FWT_SpongeMGs_ProksContigsONLY.tsv
##
