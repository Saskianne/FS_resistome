module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate DeepARG


dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/Prodigal_ALL"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_PROKS/
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/DeepARGs/DeepARG_PROKS/"
ORF_ARG_FILEs=(${DeepARGsDIR}/*.deeparg.ORF.out.mapping.ARG)

# # Original DeepARG summary script 
# ## count number of hits in ORF files
# wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1,$2}'
# ## the total hits
# awk 'NR > 1' *.deeparg.ORF.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# ## showing for each file, excluding the header
# wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_ORF_hits_perSample.txt

# ## Summary using perl script :
# INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARGs_hits_perSample.txt"  
# OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/deeparg_ALL_summary.txt"
# perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_summarize_deeparg.pl "$INPUT_FILE" "$OUTPUT_FILE"
# ##

# Summary perl script is modified: takes the column 0 and 5, ARG name and ARG class, counts and gives percentage

# DeepARG results for DeepARG run on MAGs
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/"
ORF_ARG_FILEs=(${DeepARGsDIR}/*.deeparg.ORF.out.mapping.ARG)

## count number of hits
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ORF
wc -l | awk '$1 > 1 {print $1,$2}'
## the total hits
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
awk 'NR > 1' DeepARG_ALL/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# total hits of 634 for all MAGs

## showing for each file, excluding the header
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
wc -l DeepARG_ALL/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.tsv

# Summary using perl script :
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ORF/*.deeparg.ORF.out.mapping.ARG"  
OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_BIN_Summary"
for input_file in DeepARG_ORF/*.deeparg.ORF.out.mapping.ARG ;
do 
base=$(basename $input_file ".deeparg.ORF.out.mapping.ARG")
perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions_modified.pl $input_file DeepARG_BIN_Summary/${base}.deeparg_summary.tsv
done
#

# DeepARG results for DeepARG run on MAG_drep
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL"
ORF_ARG_FILEs=(${DeepARGsDIR}/*.deeparg.ORF.out.mapping.ARG)
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
awk 'NR > 1'  DeepARG_ORF/*.deeparg.ORF.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# total hits of 168 for all MAG_drep

## showing for each file, excluding the header
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
wc -l DeepARG_ORF/*.deeparg.ORF.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_BIN_hits_perSample.txt

# Summary using perl script :
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/*.deeparg.out.mapping.ARG"  
OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/deeparg_ALL_summary.tsv"
for input_file in DeepARG_ALL/*.deeparg.out.mapping.ARG ;
do 
base=$(basename $input_file ".deeparg.out.mapping.ARG")
perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions_modified.pl $input_file DeepARG_ALL_Summary/${base}.deeparg_summary.tsv
done
#

## DeepARG results MAG_drep
#!/bin/bash

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ORF

output_file="DeepARG_MAG_all_hits_perSample.txt"
> "$output_file"  # Clear or create output file

grand_total=0
echo -e "Sample\tARG_Count" > "$output_file"

# Loop over all *.ARG files
for file in *.mapping.ARG; do
    # Count ARGs (skip header)
    count=$(awk 'NR > 1 {print $1}' "$file" | wc -l)
    basename=$(basename "$file" PROKS.deeparg.ORF.out.mapping.ARG)
    echo -e "$basename\t$count" >> "$output_file"
    grand_total=$((grand_total + count))
done

# Append the grand total to the file
echo -e "Total_ARG_hits:\t$grand_total" >> "$output_file"


