#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=MetaBat2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=metaBAT2_PROKS_MAGs.out
#SBATCH --error=metaBAT2_PROKS_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2

CONTIG_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs"
COV_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/COVERAGE_FILEs"
METABAT2_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2"

echo "START TIME": '' $(date)
for sample in ${CONTIG_FILEs}/*_contigs_min500_Proks.fna;
do
base=$(basename $sample "_contigs_min500_Proks.fna");
if [ ! -f ${METABAT2_FILEs}/${base}.metabat2.proksbin ]; then
metabat2 -t 6 -m 1500 \
     -a ${COV_FILEs}/${base}.depth.txt \
     -o ${MetaBatFiles}/${base}.metabat2.proksbin \
     -i $sample ; 
elif [ -f ${METABAT2_FILEs}/${base}.metabat2.proksbin ]; then 
     echo "File exists: ${base}.metabat2.proksbin";
else
     echo Something went wrong. 
fi     
done

echo "END TIME": '' $(date)
##
