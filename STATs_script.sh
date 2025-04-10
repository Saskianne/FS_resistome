#########################################################
## Do statistics for the reads, contigs, bins, and MAGs
#########################################################

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
MAG_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Files"
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL"
ComplCDS_Dir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/CDS_COMPLETE"
ComplORF_Dir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL/ORF_COMPLETE"

## STATS.xls files for


## RAW_Illumina
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA
sbatch -c 3 -p base --mem=50G --job-name=RAW_Illumina \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ./ "
##
## RAW_PacBio
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
sbatch -c 3 -p base --mem=50G --job-name=RAW_PacBio \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     ./"
##


cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina
## CTG_Illumina
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_Illumina \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     CONTIGs_renamed"
##
## CTG_PROKS
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_PROKS \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     CLASS_CONTIGs/PROKS"
##
## CTG_metaFlye
export PacBIO_EC_metaFlye="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/CONTIGs_metaFlye"
cd /gxfs_work/geomar/smomw681/DATA/MAG_PacBio/CONTIGs_metaFlye
sbatch -c 3 -p base --mem=50G --job-name=StatCTG_metaFlye \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $PacBIO_EC_metaFlye"
#
## MAG_Illumina
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/METABAT2_PROKS_BIN
export Illumina_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/METABAT2_PROKS_BIN"
sbatch -c 3 -p base --mem=50G --job-name=StatMAG_Illumina \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $Illumina_METABAT2_FILEs"
##
## MAG_PacBio
cd /gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye
export PacBio_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye"
sbatch -c 3 -p base --mem=50G --job-name=StatMAG_PacBio \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $PacBio_METABAT2_FILEs"
##
## MAG_ASG
cd /gxfs_work/geomar/smomw681/DATA/MAG_ASG
export ASG_MAG_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ASG"
sbatch -c 3 -p base --mem=50G --job-name=StatMAG_ASG \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $ASG_MAG_FILEs"
##
## MAG dreped
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes
export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL/dereplicated_genomes"
sbatch -c 3 -p base --mem=50G --job-name=StatMAG_drep_ALL \
     --wrap="perl /gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Fasta_Files_stats_modified_jobname.pl \
     $dREP_FILEs"
## 

# Just leave it
# CheckM2 QC report summary staticstics
export dREP_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/dREP_ALL"
export PacBio_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/METABAT2_PacBio/BIN_metaFlye"
export Illumina_METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/METABAT2_PROKS_BIN"
export ASG_MAG_FILEs="/gxfs_work/geomar/smomw681/DATA/ASG_MAG"

# ${PacBio_METABAT2_FILEs}/*.fa ${Illumina_METABAT2_FILEs}/*.fa ${ASG_MAG_FILEs}/*.fa

cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/QC_ALL/CheckM_MAG/MAGs
export MAG_sum_script="/gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Extract_bin_stats_from_bin_stats_tree_tsv_file_from_checkm_modified.pl"
export CheckM2_results_BIN="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/QC_ALL/CheckM_MAG/MAGs"
sbatch -c 3 -p base --mem=50G --job-name=StatCheckM2_BINs \
    --wrap="perl $MAG_sum_script \
    $CheckM2_results_BIN 'CheckM2_BINs.tsv'"

## CheckM2 MAG dreped summary statistics
cd /gxfs_work/geomar/smomw681/DATA/MAG_ALL/QC_ALL/CheckM_MAG
export CheckM2_MAG_drep="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/QC_ALL/CheckM_MAG/"
export MAG_sum_script="/gxfs_work/geomar/smomw681/DATA/MAG_Files/SL_Extract_bin_stats_from_bin_stats_tree_tsv_file_from_checkm_modified.pl"
sbatch -c 3 -p base --mem=50G --job-name=StatCheckM2_MAG_drep \
    --wrap="perl $MAG_sum_script \
    $CheckM2_MAG_drep 'CheckM2_MAG_drep.tsv' "



