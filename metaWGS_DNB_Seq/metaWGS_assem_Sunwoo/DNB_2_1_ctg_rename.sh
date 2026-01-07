echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES

CTG_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES"
CTG_FILES="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/*_SPADessembly/contigs.fasta"
mkdir SPADES_CONTIG_FILES
RENAMED_CTG_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES/SPADES_CONTIG_FILES"

mapfile="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/metaWGS1_DIR_SampleID_Table.txt"


for ctg_files in ${CTG_FILES[@]}; do 
    FULLDIR=$(dirname "$ctg_files")
    DIRNAME=$(basename "$FULLDIR")
    echo "$DIRNAME"
    Sample_ID=$(awk -v dir="$DIRNAME" '$1 == dir { print $2; exit }' "$mapfile" | tr -d '\r\n\')
    if [ -z "$Sample_ID" ]; then
        echo "No Sample_ID found for $DIRNAME, skipping."
        continue
    fi
    RENAME="${Sample_ID}_ctg.fasta"
    echo "Copy and rename the $ctg_files file to $RENAME"
    cp "$ctg_files" "$RENAMED_CTG_DIR/$RENAME"
done


