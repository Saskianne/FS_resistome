#!/bin/bash
#SBATCH -c 8                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_total
#SBATCH -t 12:00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p interactive                     # Partition to submit to
#SBATCH --mem=10G                  # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Illumina_assem_all.out
#SBATCH --error=Illumina_assem_all.err

# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/DATA/QC_RESULTS
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)
## Set up variables
dir1="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS" # dir for all QC results
dir2="/gxfs_work/geomar/smomw681/DATA/RAWDATA" # dir with raw fastq files
PacBio_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio"
QC_ALL_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_ALL/QC_ALL"

FILES=($dir2/*_1.fastq.gz)
BASES=(basename ${FILES[@]} "_1.fastq.gz")
PacBio_RAW=(/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs/*_1.fastq.gz)

## QC raw fastq files
dir3="${QC_ALL_DIR}/QC_RAW_ALL" # dir for QC result for raw fastq files

fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir3 ${FILES[@]} ${PacBio_RAW[@]} --threads 8
multiqc -o ${dir3} -n RAW_fastqc_summary -i RAW_fastqc_summary -p  ${dir3}


## QC assembled contigs files  
# run renaming script before QC
PacBio_EC="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Canu"

ASSEM_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
dir11="${QC_ALL_DIR}/QC_EC_ALL"    
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir11 ${ASSEM_DIR}/*_renamed.fasta ${PacBio_EC}/*/*.trimmedReads.fasta.gz 
multiqc -o ${dir11} -n EC_fastqc_summary ${dir11}






