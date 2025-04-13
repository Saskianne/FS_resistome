#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=MetaBat2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=ASG_metaBAT2_MAGs.out
#SBATCH --error=ASG_metaBAT2_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=slee@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

PacBio_Assembly="/gxfs_work/geomar/smomw681/DATA/MAG_ASG/"
MAG_ASG="/gxfs_work/geomar/smomw681/DATA/MAG_ASG"
METABAT2_FILEs="${MAG_ASG}/METABAT2_ASG"


echo "START TIME": '' $(date)
conda activate METABAT2

echo start binning with METBAT2 at $(date)
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2
for sample in /gxfs_work/geomar/smomw681/DATA/MAG_ASG/*_min500_renamed.fa;
do
base=$(basename $sample "_min500_renamed.fa");
if [ ! -f ${METABAT2_FILEs}/${base}.metabat2.asgbin.* ]; then
metabat2 -t 6 -m 1500 \
    -o ${METABAT2_FILEs}/${base}.metabat2.asgbin.fasta \
    -d -v -i $sample ; # -a ${COV_FILEs}/${base}.depth.txt: coverage information left out due to low coverage of PacBio Seq
elif [ -f ${METABAT2_FILEs}/${base}.metabat2.asgbin.* ]; then 
     echo "File exists: ${base}.metabat2.pbbin";
else
     echo Something went wrong. 
fi     
done
echo "METABAT2 binning completed at $(date)"

echo "END TIME": '' $(date)
##
