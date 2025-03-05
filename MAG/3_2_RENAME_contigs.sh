#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CtgRen
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#
# here starts your actual program call/computation
#

module load gcc12-env/12.3.0
module load gcc/12.3.0
source ~/perl5/perlbrew/etc/bashrc
perlbrew switch perl-5.38.0


cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed
echo "START TIME": '' $(date)

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*contigs_min500.fasta
do
     echo working with $i
     newfile="$(basename $i contigs_min500.fasta)"
     perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
     -i $i \
     -p "NODE" \
     -r ${newfile}_ \
     -n -a ctg > "${newfile}_contigs_min500_renamed.fasta"
done

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*scaffolds_min500.fasta
do
     echo working with $i
     newfile="$(basename $i _min500.fasta)"
     perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
     -i $i \
     -p "NODE" \
     -r ${newfile}_ \
     -n -a ctg > "${newfile}_min500_renamed.fasta"
done

echo "END TIME": '' $(date) vbv      