#!/bin/bash
#SBATCH -c 8                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_total
#SBATCH -t 12:00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p interactive                     # Partition to submit to
#SBATCH --mem=10G                  # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Illumina_assem_QC.out
#SBATCH --error=Illumina_assem_QC.err

# here starts your actual program call/computation
#

cd /gxfs_work/geomar/smomw681/DATA/QC_ALL
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)



# iterate over fastq files
# srun --pty --x11 --mem=10G -N 1 -p interactive -t 12:00:00 \
#    bash -c " 

# Set up variables
dir1="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS" # dir for all QC results
dir2="/gxfs_work/geomar/smomw681/DATA/RAWDATA" # dir with raw fastq files

FILES=($dir2/*_1.fastq.gz)
BASES=(basename ${FILES[@]} "_1.fastq.gz")

# QC raw fastq files
dir3="${dir1}/RAW_fastqc" # dir for QC result for raw fastq files

fastqc --memory 2GB -f fastq -t 4 -noextract -o $dir3 ${FILES[@]}  
multiqc -o ${dir3}/*_fastqc.zip -n RAW_fastqc_summary.txt ${dir3}   

# QC trimmed fastq files
dir4="/gxfs_work/geomar/smomw681/DATA/QCed_DATA"
QC_FILES=(${dir4}/*.fq.gz)
dir5="${dir1}/TRIM_fastqc"
fastqc --memory 2GB -t 4 -noextract -o $dir5/${BASES[@]} ${QC_FILES[@]} 
multiqc -o ${dir5}/${BASES[@]}/*fastqc.zip -n TRIM_fastqc_summary.txt       


# QC filtered fastq files
dir6="/gxfs_work/geomar/smomw681/DATA/PHIX_FILTERED"
FILTERED_FILES=(${dir6}/*.unmapped.fq.gz)
dir7="${dir1}/FILTER_fastqc"
fastqc --memory 2GB -t 4 -noextract -o ${dir7}/${BASES[@]} ${QC_FILES[@]} 
multiqc -o ${dir7}/${BASES[@]}/*fastqc.zip -n FILTER_fastqc_summary.txt 

# QC error-corrected fastq files
dir8="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
dir9="${dir1}/CORRECTION_fastqc"
fastqc --memory 2GB -t 4 -noextract -o $dir9 $dir8/*.fq.gz 
multiqc -o ${dir9}/*fastqc.zip -n CORRECTION_fastqc_summary.txt 

#QC assembled fastq files    
dir10="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
dir11="$dir1/ASSEMBLY_fastqc"    
fastqc --memory 2GB -t 4 -noextract -o $dir11 $dir10//*.fq.gz 
multiqc -o ${dir11}/*fastqc.zip -n CORRECTION_fastqc_summary.txt 


exit



echo "END TIME": '' $(date)
##