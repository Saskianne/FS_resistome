echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES

CTG_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES"

CTG_FILES="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/*_SPADessembly/contigs.fasta"

mkdir SPADES_CONTIG_FILES

for ctg_files in ${CTG_FILES[@]}; do 
    FULLDIR=$(dirname $ctg_files)
    DIRNAME=$(basename $FULLDIR)
    echo $DIRNAME
    #SAMPLE_ID =  
    #echo "Rename the $ctg_files to $FILENAME"
    # cp ctg_files
    
done
