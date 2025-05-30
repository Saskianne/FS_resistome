#!/bin/bash
#SBATCH -c 18                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=AntSMASH
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=AntiSMASH_MAG_ALL.out
#SBATCH --error=AntiSMASH_MAG_ALL.err
#
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate AntiSMASH

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/

echo "START TIME": '' $(date)

# Set up variables
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
DBDIR="/gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases"
ANTISMASH_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL"

echo "END TIME": '' $(date)
#
## Summary antiSMAH results
## 
cd /gxfs_work/geomar/smomw681/DATA/
python /gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/bin/multismash/workflow/scripts/count_regions.py \
   /gxfs_work/geomar/smomw681/DATA/MAG_PacBio/AntiSMASH_PacBio/ \
   /gxfs_work/geomar/smomw681/DATA/MAG_PacBio/AntiSMASH_PacBio/AntiSMASH_BIN_PacBio.tsv
#
# ASG
cd /gxfs_work/geomar/smomw681/DATA/
python /gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/bin/multismash/workflow/scripts/count_regions.py \
   /gxfs_work/geomar/smomw681/DATA/MAG_ASG/AntiSMASH_ASG \
   /gxfs_work/geomar/smomw681/DATA/MAG_ASG/AntiSMASH_ASG/AntiSMASH_BIN_ASG.tsv

# All MAGs
cd /gxfs_work/geomar/smomw681/DATA/
python /gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/bin/multismash/workflow/scripts/count_regions.py \
   /gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_BIN \
   /gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_BIN/AntiSMASH_BIN_ALL_new.tsv

## All contigs
cd /gxfs_work/geomar/smomw681/DATA/
python /gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/bin/multismash/workflow/scripts/count_regions.py \
   /gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_CTG \
   /gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_CTG/AntiSMASH_CTG_ALL.tsv


