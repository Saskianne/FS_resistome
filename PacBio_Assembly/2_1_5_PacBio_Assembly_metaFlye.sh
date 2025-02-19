#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem_metaFlye.out
#SBATCH --error=PacBio_assem_metaFlye.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/metaFlye"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($dir5/*_1.fastq.gz)
BASES= $(basename ${FILES} "_1.fastq.gz")

# iterate over fastq files
for fastq_file in "${FILES[@]}"; do    
     base=$(basename $fastq_file "_1.fastq.gz")
     mkdir ${dir4}/${base}
     flye --pacbio-raw $fastq_file --out-dir ${dir4}/${base} -t 8 --meta
done

echo "END TIME": '' $(date)
##