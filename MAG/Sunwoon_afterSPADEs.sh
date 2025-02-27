## STEP 1. clean the assembly folders

## cd to the directory with assemblies

# copy the script "Run_clean_spadesAssembliesDir.pl" inside there
# edit the FULL PATH to the assemblies in the script to reflect this directory

#then run the script

perl Run_clean_spadesAssembliesDir.pl

#the folders should only contain the contigs.fasta and the scafolds.fasta ONLY



## STEP 2
## rename the contig file names

cat > Find_rename_contigs_ASSEMBLEDContigs.sh

#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=FRnm6
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)

#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for fasta_file in $(find ASSEMBLIES/*/ -name "contigs.fasta"); do
    base=$(dirname $fasta_file)
    res_file_name=`echo "$(basename $base)" | cut -d'.' -f1`
    res_file_name1=$base/"$res_file_name.fna"
    mv $fasta_file $res_file_name1
    sed -i "s/>/>$res_file_name/" $res_file_name1
done
echo "END TIME": '' 'date'
##


# STEP 3
###############
## Filter contigs to retain contigs of a minimum size of 500 bp
##
#perl ~/ComGenomics/OTHERScripts/Filter_contigs_on_Size/filter_contigs_on_size.pl KRSE2011_03.raw.contigs.fasta 500
##


cat > FilterContigs_500bp.sh

#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Flt2
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/DONE/CONTIGs/RENAMED/*_SPADessembly.fasta
do
     echo working with $i
     newfile="$(basename $i SPADessembly.fasta)"; base=$(basename $i "_SPADessembly.fasta");
     perl /gxfs_home/geomar/smomw647/ComGenomicsTools/OTHERScripts/Filter_contigs_on_Size/filter_contigs_on_size.pl $i 500
done
echo "END TIME": '' 'date'
##

### STEP 4
###############
## Rename contigs
cat > rename_contigs_2.sh


#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CtgRen1
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/DONE/CONTIGs/ORIGINAL/*_SPADessembly.fna
do
     echo working with $i
     newfile="$(basename $i _SPADessembly.fna)"
     perl /gxfs_home/geomar/smomw647/ComGenomicsTools/bac-genomics-scripts/rename_fasta_id/rename_fasta_id.pl \
     -i $i \
     -p "_SPADessemblyNODE_.+$" \
     -r "_" \
     -n -a ctg > "${newfile}_SPADessembly.fasta"
done
echo "END TIME": '' 'date'
##

## STEP 5
#######################################################################
##### DeepMicroClass predictions
### DeepMicroClass: A deep learning framework for classifying metagenomic sequences
### A CNN-based multi-class classifier
## reference: https://academic.oup.com/nargab/article/6/2/lqae044/7665349?login=true#448445426
#######################################################################

####
cd /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass

cat > Run_DeepMicroClass_Batch2.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DMC2
#SBATCH -t 6-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DeepMicroClass_ouputlog_Batch2.out
#SBATCH --error=DeepMicroClass_errors_Batch2.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/CONTIGs/RENAMED_min500bp_2/*.SPADessembly.min500bp.fasta;
do
echo working with $i
CONTIGsDir="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/CONTIGs/RENAMED_min500bp_2"; 
newfile="$(basename $i .SPADessembly.min500bp.fasta)"; base=$(basename $i ".SPADessembly.min500bp.fasta");
OUTPUTDir="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/RESULTs_Sept162024"
DeepMicroClass predict \
     --input $i \
     --output_dir ${OUTPUTDir}/ \
     --encoding onehot \
     --mode hybrid \
     --device cpu; done
echo "END TIME": '' 'date'
##


## STEP 6
### EXTRACT CONTIGs FOR THE DIFFERENT CLASSES#

### HERE FOR PROKARYOTEs
cat > Extract_DeepMicroClass_Batch1_PROKS.sh

#!/bin/bash
#SBATCH -c 3                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExProks
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DMCExctract1_ouputlog_Proks.out
#SBATCH --error=DMCExctract1_errors_Proks.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/CONTIGs/RENAMED_min500bp/*.SPADessembly.min500bp.fasta;
do
echo working with $i
CONTIGsDir="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ASSEMBLIES/CONTIGs/RENAMED_min500bp"; 
base=$(basename $i ".SPADessembly.min500bp.fasta");
OUTPUTDir="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/PROKS"
TSVDir="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/RESULTs_Sept132024"
DeepMicroClass extract \
     --fasta ${CONTIGsDir}/${base}.SPADessembly.min500bp.fasta \
     --output ${OUTPUTDir}/${base}.SPADessembly.min500bp.Proks.fna \
     --class Prokaryote \
     --tsv ${TSVDir}/${base}.SPADessembly.min500bp.fasta_pred_onehot_hybrid.tsv; done
echo "END TIME": '' 'date'
##

## STEP 7
#################### STEP 6 ##############
### September 23, 2024

# PART 3
## Predict COMPLETE genes using prodigal
## Prodigal V2.6.3: February, 2016
## Include partial (incomplete) genes
## To filter these later once done
conda activate PROKKA_env
## prokka v14 1.14.6
# install
## 3.1
cd /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass

mkdir PRODIGAL
cd PRODIGAL/
mkdir GBK CDS_EDITED ORFs_EDITED CDS_ORIGINAL ORFs_ORIGINAL
cd ..


cat > Prodigal_meta_DMC_PROKARYOTIC_CONTIGs.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PrkPRK
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PProdigal_ouputlog_DMC_proks.out
#SBATCH --error=Pprodigal_errors_DMC_proks.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/PROKS_2/*.SPADessembly.min500bp.Proks.fna;
do
ProdDIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/PRODIGAL/PROKS_2"
echo working with $i
newfile="$(basename $i .SPADessembly.min500bp.Proks.fna)"
pprodigal --tasks 16 --chunksize 20000 -p meta -m \
     -i $i \
     -o ${ProdDIR}/GBB_Temp.gbk \
     -d ${ProdDIR}/CDS_ORIGINAL/"${newfile}.PROKS.CDS.fna" \
     -a ${ProdDIR}/ORFs_ORIGINAL/"${newfile}.PROKS.ORFs.faa"
done
echo "END TIME": '' 'date'
##


## STEP 8
##### EXTRACT COMPLETE GENEs (CDS) and proteins (ORFs)
## use the perl script: Extract_complete_or_partial_genes_fromProdigalPredictions.py
usage: Extract_complete_or_partial_genes_fromProdigalPredictions.py [-h] -i INPUT -o OUTPUT [-r REGEX]

# NOTE: -r partial=00 ## regex expression in the prodigcal headers for complete genes






