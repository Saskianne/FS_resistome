#!/bin/bash
#SBATCH -c 8                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_MAPPED
#SBATCH -t 2-00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                     # Partition to submit to
#SBATCH --mem=40G                  # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=QC_Mapped.out
#SBATCH --error=QC_Mapped.err

# here starts your actual program call/computation
#

cd cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

QC_RESULTS="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS" # dir for all QC results
Proks_mapped="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PROKS_mapped"
MAPPED_fastqc="${QC_RESULTS}/MAPPED_fastqc" # dir for QC result for mapped fastq files

echo "START TIME": '' $(date)

# iterate over fastq files

echo starting QC for proks_bp at $(date)
for sample in ${Proks_mapped}/*.fq.gz;
do
    base=$(basename $sample ".EC_Proks_mapped.fq.gz")
    if [ ! -f ${MAPPED_fastqc}/${base}_fastqc.zip ]; then
        echo working on $sample 
        fastqc --memory 10GB -f fastq -t 4 -noextract -o $MAPPED_fastqc $sample  
        echo fastqc file for $base is now has been created
    elif [ -f ${MAPPED_fastqc}/${base}_fastqc.zip ]; then
        echo "fastqc file $sample already exist"
    else
        echo "fastqc for $sample: something went wrong"
    fi
done

multiqc --force -o $MAPPED_fastqc -n MAPPED_fastqc_summary -i MAPPED_fastqc_summary -p ${MAPPED_fastqc}   



echo "END TIME": '' $(date)
##
