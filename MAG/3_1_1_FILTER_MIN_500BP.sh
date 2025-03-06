#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Flt2
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=15G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Filt_min_500bp.out
#SBATCH --error=Filt_min_500bp.err
# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs
MIN500bp_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs"
filtered file

echo "START TIME": '' $(date)
for i in /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/*_SPADessembly/*.fasta; do
     file=$(basename $i)
     if [ ! -f ${MIN500bp_CONTIGs}/${file} ]; then
          echo working with $i
          newfile="$(basename $i _min500.fasta)"
          base=$(basename $i ".fasta")
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_filter_contigs_on_size.pl $i 500
     else
          echo "File already exists"
     fi
done
echo "END TIME": '' $(date)
##
