#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem_wtdbg.out
#SBATCH --error=PacBio_assem_wtdbg_err.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($dir5/*_1.fastq.gz)
BASES= $(basename ${FILES} "_1.fastq.gz")

# iterate over fastq files

parallel -j 4 " \   
     base=$(basename {1} '_1.fastq.gz'); \
     wtdbg2 -x sq -t 8 -fo {2} -i {1} \
     wtpoa-cns -t 8 -i {2}.ctg.lay.gz -fo {2}.ctg.fastq
" ::: "${FILES[@]}" ::: "${BASES[@]}"

echo "END TIME": '' $(date)
##