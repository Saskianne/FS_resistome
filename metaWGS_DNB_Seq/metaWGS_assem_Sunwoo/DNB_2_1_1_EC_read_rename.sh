echo "START TIME": $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ASSEMBLIES

EC_READ_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ERROR_CORRECTED"
EC_FILES="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ERROR_CORRECTED/*.qc.ec.PE.fq.gz"
RENAMED_EC_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ERROR_CORRECTED_RENAMED"
mkdir -p $RENAMED_EC_DIR
mapfile="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/metaWGS1_DIR_SampleID_Table.txt"


for ec_files in ${EC_FILES[@]}; do 
    base=$(basename "$ec_files" .qc.ec.PE.fq.gz)
    echo "$base"
    Sample_ID=$(awk -v sample_name="${base}_SPADessembly" '$1 == sample_name { print $2; exit }' "$mapfile" | tr -d '\r\n\')
    if [ -z "$Sample_ID" ]; then
        echo "No Sample_ID found for $base, skipping."
        continue
    fi
    RENAME="${Sample_ID}.qc.ec.PE.fq.gz"
    echo "Copy and rename the $ec_files file to $RENAME"
    cp "$ec_files" "$RENAMED_EC_DIR/$RENAME"
done


