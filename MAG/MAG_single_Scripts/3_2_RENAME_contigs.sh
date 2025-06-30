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