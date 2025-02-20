#!/bin/bash
#SBATCH -c 32                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_total
#SBATCH -t 10-00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                     # Partition to submit to
#SBATCH --mem=150G                  # Memory pool for all cores (see also --mem-per-cpu)
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

dir1="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS"
dir2="/gxfs_work/geomar/smomw681/DATA/RAWDATA"
dir3="$dir1/RAW_fastqc"

dir4="/gxfs_work/geomar/smomw681/DATA/QCed_DATA"
dir5="$dir1/TRIM_fastqc"

FILES=($dir2/*_1.fastq.gz)
BASES=(basename ${FILES[@]} "_1.fastq.gz")

# iterate over fastq files
srun --pty --x11 --mem=10G -N 1 -p interactive -t 12:00:00 \
    bash -c " \
    fastqc -f fastq -t 4 * .fastq -noextract -o $dir3 ${FILES[@]} ; \
    multiqc -o $dir3/*_fastqc.zip -n RAW_fastqc_summary.txt ${dir3} "  \
    bash -c " \
    fastqc -f fastq -t 4 * .fastq -noextract -o $dir5/${BASES} "${BASES[@]}.fg"; \
    multiqc -o $dir1 ${dir3} "  \    
    
    




# dir6="/gxfs_work/geomar/smomw681/DATA/PHIX_FILTERED"
# dir7="$dir1/FILTER_fastqc"

# dir8="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
# dir9="$dir1/CORRECTION_fastqc"


# dir10="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
# dir11="$dir1/ASSEMBLY_fastqc"


exit



echo "END TIME": '' $(date)
##