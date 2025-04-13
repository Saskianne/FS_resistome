##########################
## run checkm2 for MAG
##########################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

cd /gxfs_work/geomar/smomw681/DATA/MAG_PacBio
MAG_PacBio="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio"
METABAT2_FILEs="${MAG_PacBio}/METABAT2_PacBio/BIN_metaFlye"
CheckM2_OUTPUTs="${MAG_PacBio}/CheckM2_PacBio/CheckM2_metaFlye"


# conda env config vars set CHECKM2DB="/gxfs_work/geomar/smomw681/DATABASES/CheckM_db/CheckM2_database"
#for MAG in ${METABAT2_FILEs}/*.metabat2.pbbin.fasta.*.fa; 
#do
#base=$(basename $MAG .metabat2.pbbin.fasta.*.fa)
# if [ ! -f ${CheckM2_OUTPUTs}/${base}.****]
sbatch -p base --qos=long --mem=100G -c 16 -t 2-00:00\
     --job-name=checkM2 --output=CheckM2_pbbin.out --error=CheckM2_pbbin.err\
     --wrap="checkm2 predict \
     --threads 16 \
     --extension fa \
     --input ${METABAT2_FILEs}/ \
     --output-directory ${CheckM2_OUTPUTs}/ "
#done

export ASG_MAG_FILEs="/gxfs_work/geomar/smomw681/DATA/ASG_MAG"
export CheckM2_OUTPUTs_ASG="${MAG_PacBio}/CheckM2_PacBio/CheckM2_ASG"

## CheckM Run for ASG MAGs
sbatch -p base --qos=long --mem=100G -c 16 -t 2-00:00\
     --job-name=checkM2 --output=CheckM2_ASG.out --error=CheckM2_ASG.err\
     --wrap="checkm2 predict \
     --threads 16 \
     --extension fa \
     --force \
     --input ${ASG_MAG_FILEs}/ \
     --output-directory ${CheckM2_OUTPUTs_ASG}/ "

#
################################################################################  
## Split the ASG MAGs into single .fa files for further analysis 
################################################################################ 
cd /gxfs_work/geomar/smomw681/DATA/MAG_ASG/
awk '/^>/ {header=substr($1,2); out="EunFrag_ASG_MAGs/EunFrag_ASG_" header ".fa"} {print >> out}' odEunFrag1.metagenome.1.primary.fa
awk '/^>/ {header=substr($1,2); out="SpoLacu_ASG_MAGs/SpoLacu_ASG_" header ".fa"} {print >> out}' odSpoLacu1.metagenome.1.primary.fa

# the contigs need too be assembled with MetaBAT2 and de-replicated

######################################## 
## DEREPLICATE GENOMES 
########################################
## drep-3.5.0
## De-replication is the process of identifying groups of genomes that are the “same” in a genome set, 
## and removing all but the “best” genome from each redundant set.
########################################

conda activate dRep

dRep check_dependencies
## install non-essential dependences
# conda install bioconda::centrifuge 

# cd /gxfs_work/geomar/smomw681/METABAT2/
# wget https://gembox.cbcb.umd.edu/mash/RefSeqSketchesDefaults.msh.gz
# wget https://gembox.cbcb.umd.edu/mash/RefSeqSketchesDefaults.msh.gz
# tar -xvzf RefSeqSketchesDefaults.msh.gz

export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL"
export PacBio_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye"
export Illumina_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/METABAT2_PROKS_BIN"
export ASG_MAG_FILEs="/gxfs_work/geomar/smomw681/DATA/ASG_MAG"

## unzip MAG files from ASG before running dRep
# gzip -d ${ASG_MAG_FILEs}/*.fa.gz # or 
# gunzip ${ASG_MAG_FILEs}/*.fa.gz # will also do the job

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate dRep
module load gcc/12.3.0
module load boost/1.83.0
module load cmake/3.27.4

sbatch -p base -c 18 -t 10-00:00 --qos=long --mem=240G --job-name=dREP \
     --output=dREP.out --error=dREP.err \
     --wrap="dRep dereplicate -p 6 \
     ${dREP_FILEs}/ --debug \
     -pa 0.9 -sa 0.95 -nc 0.3 \
     -l 50000 -comp 50 -con 5 \
     -ms 1000 --S_algorithm fastANI \
     -g ${PacBio_METABAT2_FILEs}/*.fa ${Illumina_METABAT2_FILEs}/*.fa ${ASG_MAG_FILEs}/*.fa "
##

########################################
## Run CheckM2 for dereplicated MAG
########################################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL
CheckM2_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/CheckM2_ALL"
dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"

#for MAG in ${METABAT2_FILEs}/*.metabat2.pbbin.fasta.*.fa; 
#do
#base=$(basename $MAG .metabat2.pbbin.fasta.*.fa)
# if [ ! -f ${CheckM2_OUTPUTs}/${base}.****]
sbatch -p base --qos=long --mem=100G -c 16 -t 2-00:00\
     --job-name=checkM2 --output=CheckM2_drep.out --error=CheckM2_drep.err\
     --wrap="checkm2 predict \
     --threads 16 \
     --extension fa \
     --force \
     --input ${dREP_FILEs}/ \
     --output-directory ${CheckM2_OUTPUTs}/ "
# done

## make statistics of CheckM2 files
CheckM2_STATs_PL="/gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Extract_bin_stats_from_bin_stats_tree_tsv_file_from_checkm.pl"
perl ${CheckM2_STATs_PL}  


########################################
## DETERMINE TAXONOMY OF dREPs
########################################
## USE GDTBK Taxonomy

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate GTDBTK
module load gsl/2.7.1
module load gcc/12.3.0
cd /gxfs_work/geomar/smomw681/DATA/

export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
export GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/GTDBTK_ALL/GTDBTK_ALL_rerun"
export MASH_DB="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/MASH_DB"
export LD_LIBRARY_PATH="/gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.27"
export GTDBTK_DATA_PATH="/gxfs_work/geomar/smomw681/DATABASES/GTDBTK_db/db"

## Check whether the GTDBTK database is downloaded and configured
# echo $GTDBTK_DATA_PATH
     # /gxfs_work/geomar/smomw681/.conda/envs/MAG/share/gtdbtk-2.4.0/db
# If not, set the GTDBTK_DATA_PATH manually
conda env config vars set GTDBTK_DATA_PATH="/gxfs_work/geomar/smomw681/DATABASES/GTDBTK_db/db"

# libgsl causes some dependency problem, so create symbolic link for libgsl.25.0
ln -s /gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.27 /gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.25
ls -l /gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.25
    

sbatch -p base -c 16 -t 10-00:00 --qos=long --mem=240G --job-name=GTDBTK2 \
     --output=GTDBTK_ALL.out --error=GTDBTK_ALL.err \
     --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa --full_tree \
     --genome_dir ${dREP_FILEs}/ \
     --mash_db ${MASH_DB}/ \
     --out_dir ${GTDBTK_OUTPUTs}/ "

# GTDBTK for BIN_metaFlye
export MAG_metaFlye="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye"
export GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/GTDBTK_ALL/GTDBTK_BIN/GTDBTK_metaFlye"
export MASH_DB="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/MASH_DB"
export LD_LIBRARY_PATH="/gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.27"
conda env config vars set GTDBTK_DATA_PATH="/gxfs_work/geomar/smomw681/DATABASES/GTDBTK_db/db"
sbatch -p base -c 10 -t 10-00:00 --qos=long --mem=240G --job-name=GTDBTK2 \
     --output=GTDBTK_BIN_metaFlye.out --error=GTDBTK_BIN_metaFlye.err \
     --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa --full_tree\
     --genome_dir ${MAG_metaFlye}/ \
     --mash_db ${MASH_DB}/ \
     --out_dir ${GTDBTK_OUTPUTs}/ "

# GTDBTK for ASG MAG
export ASG_MAG_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ASG"
export GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/GTDBTK_ALL/GTDBTK_BIN/GTDBTK_ASG"
sbatch -p base -c 6 -t 10-00:00 --qos=long --mem=240G --job-name=GTDBTK2 \
     --output=GTDBTK_MAG_ASG.out --error=GTDBTK_MAG_ASG.err \
     --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa --full_tree \
     --genome_dir ${MAG_ASG_FILEs}/ \
     --mash_db ${MASH_DB}/ \
     --out_dir ${GTDBTK_OUTPUTs}/ "
