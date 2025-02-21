#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_QC
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_filtlong.out
#SBATCH --error=PacBio_filtlong.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs/Filtlong
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs/Filtlong"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"


# iterate over fastq files
for fastq_file in ${dir5}/*.fastq.gz; do
     filtlong --min_length 1000 --keep_percent 95 filt_${fastq_file} \
     | gzip > fastq_file
done

echo "END TIME": '' $(date)
##