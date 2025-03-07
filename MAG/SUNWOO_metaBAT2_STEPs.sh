
##################
## MAP EC READS & GNERATE BAM
###################################

## 

cat > Run_generate_mapping_files.sh

#!/bin/bash
#SBATCH -c 24                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBMap
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BBmap_ouputlog_EUKS_metabat2.out
#SBATCH --error=BBMAPExctract_errors_EUKS_metabat2.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for sample in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ERROR_CORRECTED/DONE/*.qc.ec.PE.fq.gz;
do
PROK_CONTIGs="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/EUKS/TO_DO"
EC_READS="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ERROR_CORRECTED/DONE"; base=$(basename $sample ".qc.ec.PE.fq.gz");
BAM_OUT="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/BAMFILEs"
bbmap.sh ref=${PROK_CONTIGs}/${base}.SPADessembly.min500bp.Euks.fna \
     in=${EC_READS}/${base}.qc.ec.PE.fq.gz \
     out=${BAM_OUT}/${base}.out.bam \
     threads=24 pairedonly=t pigz=t \
     printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t bamscript=bs.sh; sh bs.sh; done
echo "END TIME": '' 'date'
##

##################
## SORT BAM Files
###################################


cat > Run_generate_SORT_BAM_files.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SortBm1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BBmap_ouputlog_PROKS_sortBAM.out
#SBATCH --error=BBMAPExctract_errors_PROKS_sortBAM.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for sample in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/BAMFiles_BATCH1/*.out.bam;
do
BAMFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/BAMFiles_BATCH1";
CONTIGFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/PROKS/DONE"; base=$(basename $sample ".out.bam");
samtools sort \
     -o ${BAMFiles}/${base}.out.sorted.bam \
     --output-fmt BAM \
     --threads 16 \
     --reference ${CONTIGFiles}/${base}.SPADessembly.min500bp.Proks.fna \
     ${BAMFiles}/${base}.out.bam; done
echo "END TIME": '' 'date'
##


##################
## GENERATE CONTIGs COVERAGE INFO
###################################

cat > Run_generate_COVERAGE_files.sh

#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=JGI1
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BBmap_ouputlog_EUKS_jgi_summarize.out
#SBATCH --error=BBMAPExctract_errors_EUKS_jgi_summarize.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for sample in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/BAMFILEs/DONE/*.out_sorted.bam;
do
CONTIGFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/EUKS"
BAMFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/BAMFILEs/DONE"; base=$(basename $sample ".out_sorted.bam");
COVFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/COVERAGE_FILEs_1"
jgi_summarize_bam_contig_depths \
     --outputDepth ${COVFiles}/${base}.depth.txt \
     --pairedContigs ${COVFiles}/${base}.paired.txt \
     ${BAMFiles}/${base}.out_sorted.bam \
     --referenceFasta ${CONTIGFiles}/${base}.SPADessembly.min500bp.Euks.fna; done
echo "END TIME": '' 'date'
##

##################
## GENERATE MAGs USING metaBAT2
###################################

mkdir MetaBAT2_BINS_Oct022024_238metaGs

cat > Run_metaBAT2_reconstruct_MAG.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=JGI1
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=metaBAT2_ouputlog_PROKS_MAGs.out
#SBATCH --error=metaBAT2_errors_PROKS_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for sample in /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/EUKS/*.SPADessembly.min500bp.Euks.fna;
do
MetaBatFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/MetaBAT2_BINS_Oct242024_234metaGs"; 
CONTIGFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/CLASS_CONTIGs/EUKS"; base=$(basename $sample ".SPADessembly.min500bp.Euks.fna");
COVFiles="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2_EUKS/COVERAGE_FILEs_1"
metabat2 -t 16 -m 1500 \
     -a ${COVFiles}/${base}.depth.txt \
     -o ${MetaBatFiles}/${base}.metabat2.eukbin \
     -i ${CONTIGFiles}/${base}.SPADessembly.min500bp.Euks.fna; done
echo "END TIME": '' 'date'
##


######################
## run checkm
##########################
## CheckM v2

sbatch -p base --qos=long --mem=100G -c 32 \
     --job-name=checkM2 \
     --wrap="checkm2 predict \
     --threads 32 \
     --extension fa \
     --input MetaBAT2_BINS_Oct022024_238metaGs/ \
     --output-directory CheckM2_MetaBAT2_BINS_Oct022024_238metaGs/"
#

######################################## 
## DEREPLICATE GENOMES 
########################################
## drep-3.5.0
## De-replication is the process of identifying groups of genomes that are the “same” in a genome set, 
## and removing all but the “best” genome from each redundant set.
########################################

conda create -n dREP -c bioconda drep
#conda install bioconda::drep
conda activate dREP

dRep check_dependencies
## install non-essential dependences
#conda install bioconda::centrifuge 

sbatch -p base -c 16 -t 6-00:00 --qos=long --mem=250G --job-name=dREP \
     --wrap="dRep dereplicate -p 16 \
     MetaBAT2_BINS_dREP_BINS_FINAL \
     -pa 0.9 -sa 0.95 -nc 0.3 \
     -l 50000 -comp 50 -con 10 \
     -ms 1000 --S_algorithm fastANI \
     -g FINAL_redundant_6761MAGs_ComplGreaterThan50_ContamLessThan10/*.fa"
##


########################################
## DETERMINE TAXONOMY OF dREPs
########################################
## USE GDTBK Taxonomy
## GTDB-Tk v2.4.0
## after installation in gtdbtk_v2_4_0
module load gcc12-env/12.3.0
module load miniconda3/23.5.2
conda create -n gtdbtk_v2_4_0 -c conda-forge -c bioconda gtdbtk

conda activate gtdbtk_v2_4_0
cd /gxfs_work/geomar/smomw647/DATABASES/GTDB/

#https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
#wget https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
#wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz

export http_proxy=http://10.0.7.235:3128
sbatch -p base -t 9-00:00 --qos=long --job-name=dwnload \
     --wrap="wget https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz"
##     
sbatch -p base -t 6-00:00 --qos=long --mem=120G --job-name=untar \
     --wrap="tar -xvzf gtdbtk_data.tar.gz"

##

#tar -xvzf gtdbtk_r220_data.tar.gz -C "/path/to/target/db" --strip 1 > /dev/null
rm gtdbtk_r220_data.tar.gz
conda env config vars set GTDBTK_DATA_PATH="/gxfs_work/geomar/smomw647/DATABASES/GTDB/release220/"

# Dowloaded Oct 22, 2024
##
export GTDBTK_DATA_PATH=/gxfs_work/geomar/smomw647/DATABASES/GTDB/release220
#export GTDBTK_DATA_PATH=/home/dan18/tmp/DATABASEs/GTDB-Tk_Db/release95 ##only compatible with GTDB-Tk v1.3.0
# export GTDBTK_DATA_PATH=/home/dan18/tmp/DATABASEs/GTDB-Tk_Db/release86
# Please run download-db.sh to download the database to /home/dan18/anaconda3/envs/py27/share/gtdbtk-0.1.6/db/
# or copy all data in /release68/ above to "/home/dan18/anaconda3/envs/py27/share/gtdbtk-0.1.6/db/"

cd /home/dan18/tmp/DATA_DSMZ/BASAK/ASSEMBLIES/METABAT/BINs_10Nov2021
## 
sbatch -p base -c 16 -t 6-00:00 --qos=long --mem=240G --job-name=GTDBTK1 --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa \
     --genome_dir MetaBAT2_BINS_dREP_BINS_FINAL/dereplicated_genomes/ \
     --mash_db /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/MASH_DB/ \
     --out_dir GTDBTK_RESULTS_3533dRepBINs_30Oct2024"
##




#######################################
### DETERMINE Coverage/abundance of each MAG
#######################################
## install
## CoverM v
cd /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2

module load gcc12-env/12.3.0
module load miniconda3/23.5.2
# install 
conda create -n CoverM -c bioconda -c conda-forge coverm
##
conda activate CoverM

cat > Run_coverM_3533dREP_rpkm.sh

#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CoverM
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=80G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dan18@dsmz.de  # Email to which notifications will be sent
##
# here starts your actual program call/computation
#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
for sample in `ls /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ERROR_CORRECTED/DONE/*.qc.ec.PE.fq.gz`;
do
READS_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/ERROR_CORRECTED/DONE";
Genomes_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/MetaBAT2_BINS_dREP_BINS_FINAL/dereplicated_genomes"
CoverM_DIR="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/CoverM_RESULTs_MetaBAT2_BINS_dREP_3533BINS_FINAL_rpkm"; base=$(basename $sample ".qc.ec.PE.fq.gz");
coverm genome \
     -t 32 \
     --mapper minimap2-sr \
     --min-read-percent-identity 0.95 \
     --min-read-aligned-percent 0.80 \
     --min-covered-fraction 10 \
     --methods rpkm \
     --interleaved ${READS_DIR}/${base}.qc.ec.PE.fq.gz \
     --genome-fasta-extension fa \
     --genome-fasta-directory ${Genomes_DIR}/ \
     --output-file ${CoverM_DIR}/${base}.coverm_3533dRepMAGs.tsv
done
#
echo "END TIME": '' 'date'
#


