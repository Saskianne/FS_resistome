module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/NANOPORE_DATA/
FILTERER_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/DEMULTIPLEXED/NANOPORE_16S_FILTERED"
EMU_DIR="/gxfs_work/geomar/smomw681/NANOPORE_DATA/EMU/EMU_N16S_ind"
EMU_FILES=($EMU_DIR/*rel-abundance.tsv)
cd $EMU_DIR
# Create a tsv for file for EMU output concatenation
>N16S_EMU_rel_abundance_concat.tsv

head -n 1 ${EMU_FILES[0]} | awk '{ print $0 "\tsampleID" }' > N16S_EMU_rel_abundance_concat.tsv
# awk  -F '\t' ' { OFS = "\t" ; print $0 }' header_temp.tsv > N16S_EMU_rel_abundance_concat.tsv

# Concatenate all EMU files into a single TSV file
for emu_file in ${EMU_FILES[@]}; do 
    sampleID=$(basename $emu_file .tsv | sed 's/_renamed_filt_rel-abundance//')
    tail -n +2 $emu_file > wo_header_temp.tsv
    awk -v SampleID="$sampleID" '{ OFS = "\t"; print $0, SampleID }' wo_header_temp.tsv >> N16S_EMU_rel_abundance_concat.tsv
done
rm header_temp.tsv
rm wo_header_temp.tsv

# the column names are now:
tax_id abundance species genus family order class phylum clade superkingdom subspecies species subgroup species group estimated counts sampleID

# Check whether everything's worked
count=0
awk -v count=$count '/sampleID/ {count = count + 1} END { print count}' N16S_EMU_rel_abundance_concat.tsv
awk 'END { print NR }' N16S_EMU_rel_abundance_concat.tsv
awk 'END { print NR }' /gxfs_work/geomar/smomw681/NANOPORE_DATA/EMU/EMU_N16S_ind/FWP1D0318R12_renamed_filt_rel-abundance.tsv

tmp=$(head -1 fN16S_EMU_rel_abundance_concat.tsv)
echo "$tmp" | grep -q '[:space:]' && echo 'has white space: tab or spaces' 
echo "$tmp" | grep -q ',' && echo 'has commas'
echo "$tmp" | grep -q '|' && echo 'has pipe symbols'

# check whether there is any archaea in the dataset
awk -F '\t' '$10 == "Archaea" { print $0 }' N16S_EMU_rel_abundance_concat.tsv | head -n 5 
