#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_total
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Illumina_assem_QC.out
#SBATCH --error=Illumina_assem_QC.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/QC_ALL
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir1="/gxfs_work/geomar/smomw681/DATA/RAWDATA/QC_ALL"
dir2="/gxfs_work/geomar/smomw681/DATA/RAWDATA"
dir3="/gxfs_work/geomar/smomw681/DATA/QCed_DATA"
dir4="/gxfs_work/geomar/smomw681/DATA/PHIX_FILTERED"
dir5="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
dir6="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"

# iterate over fastq files
for fastq_file in ${dir2}/*.fastq.gz; do
     fastqc -t 4 -f fastq -noextract $fastq_file -o ${dir1};
     multiqc -o ${dir1} ${dir1}
done


echo "END TIME": '' $(date)
##