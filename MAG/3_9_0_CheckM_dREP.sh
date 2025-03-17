######################
## run checkm
##########################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2
METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/PROKS_BIN"
CheckM2_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/CheckM2"


for MAG in ${METABAT2_FILEs}/*.metabat2.proksbin.fasta.*.fa; 
do
base=$(basename $MAG .metabat2.proksbin.fasta.*.fa)
# if [ ! -f ${CheckM2_OUTPUTs}/${base}.****]
sbatch -p base --qos=long --mem=100G -c 16 -t 2-00:00\
     --job-name=checkM2 --output=CheckM2_proksbin.out --error=CheckM2_proksbin.err\
     --wrap="checkm2 predict \
     --threads 16 \
     --extension fa \
     --input ${METABAT2_FILEs}/ \
     --output-directory ${CheckM2_OUTPUTs}/"
done
#

######################################## 
## DEREPLICATE GENOMES 
########################################
## drep-3.5.0
## De-replication is the process of identifying groups of genomes that are the “same” in a genome set, 
## and removing all but the “best” genome from each redundant set.
########################################

conda activate MAG

dRep check_dependencies
## install non-essential dependences
#conda install bioconda::centrifuge 
cd /gxfs_work/geomar/smomw681/METABAT2/
wget https://gembox.cbcb.umd.edu/mash/RefSeqSketchesDefaults.msh.gz
wget https://gembox.cbcb.umd.edu/mash/RefSeqSketchesDefaults.msh.gz
tar -xvzf RefSeqSketchesDefaults.msh.gz

dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/dREP_PROKS_BIN"

sbatch -p base -c 17 -t 6-00:00 --qos=long --mem=250G --job-name=dREP \
     --output=dREP.out --error=dREP.err \
     --wrap="dRep dereplicate -p 6 \
     ${dREP_FILEs}/ \
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
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/
GTDBTK_OUTPUTs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/GTDBTK_PROKS"


sbatch -p base -c 16 -t 6-00:00 --qos=long --mem=240G --job-name=GTDBTK1 --wrap="gtdbtk classify_wf \
     --cpus 16 -x fa \
     --genome_dir ${dREP_FILEs}/ \
     --mash_db /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/DEEPMicroClass/METABAT2/MASH_DB/ \
     --out_dir GTDBTK_PROKS"
