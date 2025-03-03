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



# iterate over fastq files
# srun --pty --x11 --mem=10G -N 1 -p interactive -t 12:00:00 \
#    bash -c " 

## Set up variables
dir1="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS" # dir for all QC results
dir2="/gxfs_work/geomar/smomw681/DATA/RAWDATA" # dir with raw fastq files

FILES=($dir2/*_1.fastq.gz)
BASES=(basename ${FILES[@]} "_1.fastq.gz")

## QC raw fastq files
dir3="${dir1}/RAW_fastqc" # dir for QC result for raw fastq files

fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir3 ${FILES[@]}  
multiqc -o $dir3 -n RAW_fastqc_summary -i RAW_fastqc_summary -p  ${dir3}   

## QC trimmed fastq files
dir4="/gxfs_work/geomar/smomw681/DATA/QCed_DATA"
QC_FILES=(${dir4}/*.fq.gz)
dir5="${dir1}/TRIM_fastqc"
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir5 ${QC_FILES[@]} 
multiqc -o ${dir5} -n TRIM_fastqc_summary -i TRIM_fasqc_summary -p ${dir5}      


## QC filtered fastq files
dir6="/gxfs_work/geomar/smomw681/DATA/PHIX_FILTERED"
FILTERED_FILES=(${dir6}/*.unmapped.fq.gz)
dir7="${dir1}/FILTER_fastqc"
fastqc --memory 10GB -f fastq -t 4 -noextract -o ${dir7} ${QC_FILES[@]} 
multiqc -o ${dir7}/*fastqc.zip -n FILTER_fastqc_summary -i FILTER_fastqc_summary ${dir7}

## QC error-corrected fastq files
dir8="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
dir9="${dir1}/CORRECTION_fastqc"
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir9 ${dir8}/*.fq.gz 
multiqc -o ${dir9}/*fastqc.zip -n CORRECTION_fastqc_summary -i CORRECTION_fastqc_summary ${dir9}

## QC assembled fastq files    
# run renaming script before QC
dir10="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
ASSEM_DIR=(${dir10}/*_SPADessembly)
#ASSEM_QC_DIR=$(basename ${ASSEM_DIR[@]} "_SPADessembly")
dir11="${dir1}/ASSEMBLY_fastqc"    
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir11 ${ASSEM_DIR[@]}/contigs.fasta 
multiqc -o ${dir11}/*fastqc.zip -n ASSEMBLY_fastqc_summary ${dir11}

## exit


echo "END TIME": '' $(date)
###