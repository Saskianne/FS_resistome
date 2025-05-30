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
CTG_PacBio_DIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/metaFlye"
CTG_Illumina_Dir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
DBDIR="/gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases"
ANTISMASH_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_CTG"

for file in ${CTG_Illumina_Dir}/*.fasta; do
base=$(basename $file "_renamed.fasta")
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

for file in ${CTG_PacBio_DIR}/*/*.fasta; do
base=$(basename $file "_assembly.fasta")
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

# for 
# SRR15145662
# SRR15145666
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate AntiSMASH

export CTG_Illumina_Dir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
export DBDIR="/gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases"
export ANTISMASH_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_CTG"


sbatch --cpus-per-task=10 --mem=100G --time=48:00:00 -wrap="antismash \
     -t bacteria \
     --cpus 8 \
     --databases /gxfs_work/geomar/smomw681/.conda/envs/AntiSMASH/lib/python3.10/site-packages/antismash/databases/ \
     --output-dir /gxfs_work/geomar/smomw681/DATA/MAG_ALL/AntiSMASH_ALL/AntiSMASH_CTG/SRR15145662_contigs_min500/ \
     --html-title SRR15145662_antiSMASH \
     --output-basename SRR15145662 \
     --genefinding-tool prodigal-m \
     /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed/SRR15145662_contigs_min500_renamed.fasta"

sbatch --cpus-per-task=16 --mem=150G -t 48:00:00 --wrap="antismash \
     -t bacteria \
     --cpus 8 \
     --databases ${DBDIR}/ \
     --output-dir ${ANTISMASH_DIR}/SRR15145666_contigs_min500/ \
     --html-title SRR15145666_antiSMASH \
     --output-basename SRR15145666 \
     --genefinding-tool prodigal-m \
     /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed/SRR15145666_contigs_min500_renamed.fasta"
