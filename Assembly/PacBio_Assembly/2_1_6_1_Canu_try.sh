#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem_Canu_try.out
#SBATCH --error=PacBio_assem_Canu_try.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/Canu"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"

cd /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/Canu
# iterate over fastq files
     base=$(basename ERR13615510.fastq.gz ".fastq.gz")

     sbatch --cpus-per-task=2 --mem=80G --time 2-00:00 \
          --wrap="canu  \
          -p ${base} genomeSize=7m -d ${dir4}/${base} \
          -pacbio-raw ERR13615510.fastq.gz "


echo "END TIME": '' $(date)
##