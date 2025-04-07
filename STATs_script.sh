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

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina
## STATS.xls files for

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

## 

