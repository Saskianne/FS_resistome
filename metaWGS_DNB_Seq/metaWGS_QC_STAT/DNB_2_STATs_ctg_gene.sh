#!/bin/bash
##
## Shell script to submit the python script for statistics about contig files and gene calling files. 

metaWGS_DAVID_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID"
ASSEM_DIR="$metaWGS_DAVID_DIR/ASSEMBLIES"
metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
DMC_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/DeepMicroClass"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
ProdDIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/PRODIGAL"
ComplCDS_Dir="$ProdDIR/CDS_COMPLETE"
ComplORF_Dir="$ProdDIR/ORF_COMPLETE"
STAT_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/DNB_WGS_QC_STAT/STATISTICS"
mkdir /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/DNB_WGS_QC_STAT/STATISTICS

cd $STAT_DIR


## STATS.xls files for:

## CTG_DNB metaWGS Seq
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_DNB \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ${ASSEM_DIR}/CTGs_renamed"
##

## CTG_DNB metaWGS Seq filtered by length > 500 bp
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_DBN_FILT \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ${ASSEM_DIR}/MIN500bp_CONTIGs"
##

## CTG_PROKS
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_PROKS \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $PROKS_DIR"
##

## ORFs
sbatch -c 3 -p base --mem=50G --job-name=StatORF_PROKS \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ${ProdDIR}/ORFs_ORIGINAL"
##
## CDS
sbatch -c 3 -p base --mem=50G --job-name=StatCDS_PROKS \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ${ProdDIR}/CDS_ORIGINAL"