module load gcc12-env/12.3.0
module load gcc/12.3.0
source ~/perl5/perlbrew/etc/bashrc
perlbrew switch perl-5.38.0

CTGs_renamed_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/ASSEMBLY/CTGs_renamed"
mkdir -p $CONTIGs_renamed_DIR
cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/ASSEMBLY/CTGs_renamed
MIN500bp_CONTIGs_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/MIN500bp_CONTIGs"

echo start renaming

for i in ${MIN500bp_CONTIGs_DIR}/*_ctg_min500.fasta; do
     file=$(basename $i)
     base=$(basename $i "_ctg_min500.fasta")
     newfile="${base}_ctg_min500_renamed.fasta"
     if [ ! -f ${CTGs_renamed_DIR}/${newfile} ]; then
          echo working with $i
          perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_rename_fasta_id.pl \
          -i $i \
          -p "NODE" \
          -r ${base}_ \
          -n -a ctg > "${base}_ctg_min500_renamed.fasta"
     else 
          echo "File ${file} already exists in ${CTCs_renamed_DIR}"
     fi
done 


# echo "END TIME": '' $(date)
##