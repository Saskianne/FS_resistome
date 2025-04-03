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

export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/dREP_PROKS_BIN"
export METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/METABAT2_PROKS_BIN"

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
     -g ${METABAT2_FILEs}/*.fa "
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

export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/dREP_PROKS_BIN/dereplicated_genomes"
export GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/GTDBTK_PROKS"
export MASH_DB="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/MASH_DB"


sbatch -p base -c 16 -t 10-00:00 --qos=long --mem=240G --job-name=GTDBTK1 \
     --output=GTDBTK.out --error=GTDBTK.err \
     --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa \
     --genome_dir ${dREP_FILEs}/ \
     --mash_db ${MASH_DB}/ \
     --out_dir ${GTDBTK_OUTPUTs}/ "
