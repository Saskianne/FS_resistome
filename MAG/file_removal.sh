

cd /gxfs_work/geomar/smomw681/DATA
dir1="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
FILES=(${dir1}/*_SPADessembly)
for file in ${FILES[@]};do
    find $file -mindepth 1 ! \
    -name "contigs.fasta" ! -name "scaffolds.fasta" -exec rm -rf {} +
    echo "Files cleaned for the directory $file"
done