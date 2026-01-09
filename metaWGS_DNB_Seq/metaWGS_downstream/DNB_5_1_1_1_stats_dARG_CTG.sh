#!/bin/bash

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
ProdDIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/PRODIGAL"
ComplCDS_Dir="${ProdDIR}/CDS_COMPLETE"
ComplORF_Dir="${ProdDIR}/ORF_COMPLETE"
DeepARG_DIR="${metaWGS_SUNWOO_DIR}/DeepARG"
dARG_ORF_DIR="${DeepARG_DIR}/DeepARG_ORF"
dARG_CDS_DIR="${DeepARG_DIR}/DeepARG_CDS"

## count number of hits in ORF
cd ${dARG_ORF_DIR}
wc -l | awk '$1 > 1 {print $1,$2}'

## the total ARG hits in ORF
cd $dARG_ORF_DIR
awk 'NR > 1' DeepARG_ALL/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
# total hits: 

## showing for each file, excluding the header
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
wc -l DeepARG_ALL/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.tsv

# Summary using perl script :
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
for input_file in DeepARG_ALL/*.deeparg.out.mapping.ARG ;
do 
base=$(basename $input_file ".deeparg.out.mapping.ARG")
INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/*.deeparg.out.mapping.ARG"  
OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARG_ALL/deeparg_ALL_summary.tsv"
perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions.pl $input_file DeepARG_ALL_Summary/${base}.deeparg_summary.tsv
done
#