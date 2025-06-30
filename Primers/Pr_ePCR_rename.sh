module load gcc12-env/12.3.0
module load gcc/12.3.0
source ~/perl5/perlbrew/etc/bashrc
perlbrew switch perl-5.38.0


cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/WGS_JUTTA_STRAIN
WGS_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/WGS_JUTTA_STRAIN"
WGS_CTG_renamed="/gxfs_work/geomar/smomw681/NANOPORE_DATA/ARG_BLAST_JUTTA/WGS_JUTTA_STRAIN/WGS_renamed"
echo start renaming

> ${WGS_CTG_renamed}/Jutta_Strains_WGS_all_renamed.fasta 
for i in ${WGS_DIR}/*.fasta
do
     file=$(basename $i)
     base=$(basename $i ".fasta")
     newfile="${base}_CTG_renamed.fasta"
     if [ ! -f ${WGS_CTG_renamed}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
          -i $i \
          -p "contig" \
          -r ${base}_contig_ \
          -n > ${WGS_CTG_renamed}/"${base}_CTG_renamed.fasta"
          cat ${WGS_CTG_renamed}/"${base}_CTG_renamed.fasta" >> ${WGS_CTG_renamed}/Jutta_Strains_WGS_all_renamed.fasta 
     else 
          echo "File ${file} already exists in ${WGS_CTG_renamed}, skipping."
     fi
done

echo done with renaming 

## renaming contigs for all of Jutta's strains and combine all into a single fasta file. 
cd /gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/GENOMEs_ALL
WGS_DIR="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/GENOMEs_ALL"
WGS_CTG_renamed="/gxfs_work/geomar/smomw681/DATA/GENOME_Jutta/GENOMEs_ALL/JUTTA_WGS_CTG_renamed"
echo start renaming

> ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta 
for i in ${WGS_DIR}/*.fasta
do
     file=$(basename $i)
     base=$(basename $i ".fasta")
     newfile="${base}_CTG_renamed.fasta"
     if [ ! -f ${WGS_CTG_renamed}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
          -i $i \
          -p "contig" \
          -r ${base}_contig_ \
          -n > ${WGS_CTG_renamed}/"${base}_CTG_renamed.fasta"
          cat ${WGS_CTG_renamed}/"${base}_CTG_renamed.fasta" >> ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta  
     else 
          echo "File ${file} already exists in ${WGS_CTG_renamed}, skipping." 
     fi
done

# remove unnecessary files from the directory and repeat 
> ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta 
for i in ${WGS_CTG_renamed}/*_renamed.fasta
do 
     cat $i >> ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta
     echo Added $i to JUTTA_WGS_all_renamed.fasta
done

# split the file into 4 different files to reduce the size 
sed -n '1,2186761p' ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta > ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed_1.fasta
sed -n '2186761,4055945p' ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta > ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed_2.fasta
sed -n '4055945,6338596p' ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta > ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed_3.fasta
sed -n '4055945,8405273p' ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed.fasta > ${WGS_CTG_renamed}/JUTTA_WGS_all_renamed_4.fasta

echo done with renaming 

echo "END TIME": '' $(date)
##
