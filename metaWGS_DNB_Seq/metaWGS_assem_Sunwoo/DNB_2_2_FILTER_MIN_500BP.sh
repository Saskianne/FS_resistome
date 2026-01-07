#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Flt2
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=15G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_2_2_Filt_min_500bp.out
#SBATCH --error=DNB_2_2_Filt_min_500bp.err
# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES
MIN500bp_CONTIGs_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/MIN500bp_CONTIGs"
# mkdir -p $MIN500bp_CONTIGs_DIR
RENAMED_CTG_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/SPADES_CONTIG_FILES"

echo "START TIME": '' $(date)
for i in ${RENAMED_CTG_DIR}/*.fasta; do
     base=$(basename $i ".fasta")
     newfile="${base}_min500.fasta"
     if [ ! -f ${MIN500bp_CONTIGs_DIR}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_filter_contigs_on_size.pl $i 500
     else
          echo "File already exists"
     fi
done
echo "END TIME": '' $(date)
##