#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CtgRen
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#
# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed
echo "START TIME": '' $(date)
for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*contigs_min500.fasta
do
     echo working with $i
     newfile="$(basename $i _min500.fasta)"
     perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
     -i $i \
     -p "_SPADessemblyNODE_.+$" \
     -r "_" \
     -n -a ctg > "${newfile}_renamed.fasta"
done

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/MIN500bp_CONTIGs/*scaffolds_min500.fasta
do
     echo working with $i
     newfile="$(basename $i _min500.fasta)"
     perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
     -i $i \
     -p "NODE" \
     -r ${newfile} \
     -n -a ctg > "${newfile}_renamed.fasta"
done

echo "END TIME": '' $(date) vbv      