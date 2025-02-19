#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem.out
#SBATCH --error=PacBio_assem_err.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs/QC_metrics"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"


# iterate over fastq files
for fastq_file in ${dir5}/*.fastq.gz; do
     fastqc -t 4 -f fastq -noextract $fastq_file -o ${dir4};
     multiqc -o ${dir4} ${dir4}
done

echo "END TIME": '' $(date)
##