#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ASSEM
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=ASSEMBLY_ALL_P1.out
#SBATCH --error=ASSEMBLY_ALL_P1.err
# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs
MIN500bp_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs"

echo "START TIME": '' $(date)
echo min 500bp filtering starts

for i in /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/*_SPADessembly/*.fasta; do
     file=$(basename $i)
     base=$(basename $i ".fasta")
     newfile="${base}_min500.fasta"
     if [ ! -f ${MIN500bp_CONTIGs}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_filter_contigs_on_size.pl $i 500
     else
          echo "File already exists"
     fi
done

echo min 500bp filtering done

module load gcc12-env/12.3.0
module load gcc/12.3.0
source ~/perl5/perlbrew/etc/bashrc
perlbrew switch perl-5.38.0


cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed
CONTIGs_renamed="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
echo start renaming

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*contigs_min500.fasta
do
     file=$(basename $i)
     base=$(basename $i "_contigs_min500.fasta")
     newfile="${base}_contigs_min500_renamed.fasta"
     if [ ! -f ${CONTIGs_renamed}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
          -i $i \
          -p "NODE" \
          -r ${base}_ \
          -n -a ctg > "${base}_contigs_min500_renamed.fasta"
     else 
          echo "File ${file} already exists in ${CONTIGs_renamed}"
     fi
done


echo start renaming scaffolds
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed/SCAFFOLDS
for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*scaffolds_min500.fasta
do
    file=$(basename $i)
    base=$(basename $i "_min500.fasta")
    newfile="${base}_min500_renamed.fasta"
    if [ ! -f ${CONTIGs_renamed}/SCAFFOLDS/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
          -i $i \
          -p "NODE" \
          -r ${base} \
          -n -a ctg > "${base}_min500_renamed.fasta"
     else 
          echo "File ${file} already exists in ${CONTIGs_renamed}"
     fi
done

echo done with renaming 

echo "END TIME": '' $(date)
##