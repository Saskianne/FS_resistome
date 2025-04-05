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

## count number of hits in ORF files
wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1,$2}'
## the total hits
awk 'NR > 1' *.deeparg.ORF.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
## showing for each file, excluding the header
wc -l *.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_ORF_hits_perSample.txt


# DeepARG results for DeepARG run on drep_MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/
DeepARGsDIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/"
ORF_ARG_FILEs=(${DeepARGsDIR}/*.deeparg.ORF.out.mapping.ARG)

## count number of hits in ORF files
wc -l *.deeparg.ORF.out.mapping.ARG | awk '$1 > 1 {print $1,$2}'
## the total hits
awk 'NR > 1' *.deeparg.ORF.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
## showing for each file, excluding the header
wc -l *.deeparg.ORF.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_ORF_hits_perSample.txt

CDS_ARG_FILEs=(${DeepARGsDIR}/DeepARG_CDS/*.deeparg.CDS.out.mapping.ARG)
## count number of hits in CDS files
wc -l | awk '$1 > 1 {print $1,$2}'
## the total hits
awk 'NR > 1' DeepARG_CDS/*.deeparg.CDS.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
## showing for each file, excluding the header
wc -l DeepARG_CDS/*.deeparg.CDS.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_CDS_hits_perSample.txt


## Summary using perl script :
INPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/DeepARGs_hits_perSample.txt"  
OUTPUT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/DeepARG_ALL/deeparg_ALL_summary.txt"
SUMMARY_PERL_SCRIPT_FILE="/gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Summarize_deeparg_out_mapping_ARG_with_InOutOptions.pl"
perl $SUMMARY_PERL_SCRIPT_FILE "$INPUT_FILE" "$OUTPUT_FILE"
##


