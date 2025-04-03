###### EXTRACT COMPLETE GENEs
## CDS

cat > Extract_CompleteGenes_CDS.sh

#!/bin/bash
#SBATCH -c 3                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExCDS
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=25G                 # Memory pool for all cores (see also --mem-per-cpu)
##
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/CDS_ORIGINAL/*.PROKS.CDS.fna
do
Input_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/CDS_ORIGINAL/"
Output_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/COMPLETE_CDS"
echo working with $i
newfile="$(basename $i .PROKS.CDS.fna)"
base=$(basename $i ".PROKS.CDS.fna")
python /gxfs_home/geomar/smomw647/ComGenomicsTools/OTHERScripts/Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i ${Input_DIR}/${base}.PROKS.CDS.fna \
     -o ${Output_DIR}/${base}.COMPLETE.PROKS.CDS.fna \
     -r partial=00
done
echo "END TIME": '' 'date'
##

## ORFs
cat > Extract_CompleteGenes_ORFs.sh

#!/bin/bash
#SBATCH -c 3                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExORFs
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=25G                 # Memory pool for all cores (see also --mem-per-cpu)
##
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/ORFs_ORIGINAL/*.PROKS.ORFs.faa
do
Input_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/ORFs_ORIGINAL/"
Output_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/COMPLETE_ORFs"
echo working with $i
newfile="$(basename $i .PROKS.ORFs.faa)"
base=$(basename $i ".PROKS.ORFs.faa")
python /gxfs_home/geomar/smomw647/ComGenomicsTools/OTHERScripts/Extract_complete_or_partial_genes_fromProdigalPredictions.py \
     -i ${Input_DIR}/${base}.PROKS.ORFs.faa \
     -o ${Output_DIR}/${base}.COMPLETE.PROKS.ORFs.faa \
     -r partial=00
done
echo "END TIME": '' 'date'
##


## STATS for

## CDS
sbatch -c 3 -p base --mem=50G --job-name=StatCTGs \
     --wrap="perl $HOME/ComGenomicsTools/OTHERScripts/Fasta_Files_stats_2024_version.pl \
     CONTIGs/RENAMED/"
##
## ORFs
sbatch -c 3 -p base --mem=50G --job-name=StatORFs \
     --wrap="perl $HOME/ComGenomicsTools/OTHERScripts/Fasta_Files_stats_2024_version.pl \
     ORFs/"
##
## CDS
sbatch -c 3 -p base --mem=50G --job-name=StatCDS2 \
     --wrap="perl $HOME/ComGenomicsTools/OTHERScripts/Fasta_Files_stats_2024_version.pl \
     CDS_ORIGINAL/"
##


####### 
conda activate DeepARG

cd 
cat > Run_DeepARGs_all_4866MAGs.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dARGS
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=dARGs_FWTSponges_ouputlog.out
#SBATCH --error=dARGs_FWTSponges_errors.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/COMPLETE_ORFs/*.COMPLETE.PROKS.ORFs.faa;
do
ORFsDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/COMPLETE_ORFs"; base=$(basename $i ".COMPLETE.PROKS.ORFs.faa");
RESULTsDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL/DeepARGs"
DBDIR="/gxfs_work/geomar/smomw647/DATABASES/DeepARG"
deeparg predict \
    --model LS \
    -i ${ORFsDIR}/${base}.COMPLETE.PROKS.ORFs.faa \
    -o ${RESULTsDIR}/${base}.deeparg.out \
    -d ${DBDIR}/ \
    --type prot \
    --min-prob 0.8 \
    --arg-alignment-identity 50 \
    --arg-alignment-evalue 1e-10 \
    --arg-num-alignments-per-entry 1000; done
echo "END TIME": '' 'date'
##

## count number of hits
wc -l | awk '$1 > 1 {print $1,$2}'
## the total hits
awk 'NR > 1' DeepARGs/*.deeparg.out.mapping.ARG | wc -l | awk '$1 > 1 {print $1,$2}'
## showing for each file, excluding the header
wc -l DeepARGs/*.deeparg.out.mapping.ARG | awk '$1 > 1 {print $1-1,$2}' > DeepARGs_hits_perSample.txt






###########################################
### DEEPBGCs
######### January 6, 2025
###########################################

conda activate DeepBGC

cd /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PRODIGAL

mkdir DeepBGCs_PROKS
 
cat > Run_DeepBGC_all_PROKS_Contigs_BatchMODE.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=dBGC
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=300G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepBGC_Proks_output_Bacthmode0.out
#SBATCH --error=DeepBGC_Proks_run_errors_Bacthmode0.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
InputDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/PROKS"
OutputDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/DeepBGCs_PROKS"
FILES=($InputDIR/*_contigs_min500_Proks.fna)

# Iterate through files in batches of 4
for (( i=0; i<${#FILES[@]}; i+=4 )); do
batch=("${FILES[@]:i:4}")
for file in "${batch[@]}"; do
base=$(basename $file "_contigs_min500_Proks.fna")
newfile="$(basename $file _contigs_min500_Proks.fna)"
sbatch --cpus-per-task=2 --mem=80G --wrap="deepbgc pipeline \
     --score 0.5 \
     --prodigal-meta-mode \
     --output ${OutputDIR}/${base}/ \
     ${InputDIR}/${base}_contigs_min500_Proks.fna"
done
done

echo "END TIME": '' 'date'
#


###########################################
### AntiSMAH
######### January 6, 2025
###########################################
conda activate AntiSMASH
cd /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs
conda activate AntiSMASH
mkdir AntiSMASH_PROKS/
### 

cat > Run_AntiSMASH_all_PROKContigs_BatchMODE.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=AntSMASH
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=350G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=AntiSMASH_PROKContigs_logouput.out
#SBATCH --error=AntiSMASH_PROKContigs_run_errors.err
#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
InputDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/PROKS"
DBDIR="/gxfs_work/geomar/smomw647/DATABASES/AntiSMASH"
OutputDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/AntiSMASH_PROKS"
FILES=($InputDIR/*_contigs_min500_Proks.fna)

# Iterate through files in batches of 4
for (( i=0; i<${#FILES[@]}; i+=4 )); do
batch=("${FILES[@]:i:4}")
for file in "${batch[@]}"; do
base=$(basename $file "_contigs_min500_Proks.fna")
newfile="$(basename $file _contigs_min500_Proks.fna)"
sbatch --cpus-per-task=2 --mem=80G --wrap="antismash \
     -t bacteria \
     --cpus 16 \
     --databases ${DBDIR}/ \
     --output-dir ${OutputDIR}/${base}/ \
     --output-basename ${base} \
     --genefinding-tool prodigal-m \
     ${InputDIR}/${base}_contigs_min500_Proks.fna"
done
done

echo "END TIME": '' 'date'
#

## Summary antiSMAH results
## 
python /gxfs_work/geomar/smomw647/ComGenomicsTools/multismash/workflow/scripts/count_regions.py \
     /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/CLASS_CONTIGs/AntiSMASH_PROKS/ \
     AntiSMASH_PROKS_FWT_SpongeMGs_ProksContigsONLY.tsv
##

