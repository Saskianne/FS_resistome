######################
## run checkm
##########################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

MAG_PacBio="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio"
metaFLYE_CONTIG_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/CONTIGs_metaFlye"
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/BAMFILEs_PacBio/BAM_metaFlye"
COV_FILEs="${MAG_PacBio}/COVERAGE_PacBio/COV_metaFlye"


cd /gxfs_work/geomar/smomw681/DATA/MAG_PacBio
MAG_PacBio="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio"
METABAT2_FILEs="${MAG_PacBio}/METABAT2_PacBio/BIN_metaFlye"
CheckM2_OUTPUTs="${MAG_PacBio}/CheckM2_PacBio/CheckM2_metaFlye"


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
     --input ${ASG_MAG_FILEs}/ \
     --output-directory ${CheckM2_OUTPUTs_ASG}/ "

#

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
export GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/GTDBTK_ALL"
export MASH_DB="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/MASH_DB"
export LD_LIBRARY_PATH="/gxfs_work/geomar/smomw681/.conda/envs/GTDBTK/lib/libgsl.so.27"


sbatch -p base -c 16 -t 10-00:00 --qos=long --mem=240G --job-name=GTDBTK2 \
     --output=GTDBTK_ALL.out --error=GTDBTK_ALL.err \
     --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa \
     --genome_dir ${dREP_FILEs}/ \
     --mash_db ${MASH_DB}/ \
     --out_dir ${GTDBTK_OUTPUTs}/ "




