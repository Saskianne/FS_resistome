#!/bin/bash
#SBATCH -c 8                       # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=QC_total
#SBATCH -t 2-00:00                 # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                     # Partition to submit to
#SBATCH --mem=40G                  # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Illumina_assem_62.out
#SBATCH --error=Illumina_assem_62.err


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

FILES=($dir2/SRR15145662_1.fastq.gz)
BASES=(basename ${FILES[@]} "_1.fastq.gz")

## QC error-corrected fastq files
dir8="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
dir9="${dir1}/CORRECTION_fastqc"
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir9 ${dir8}/SRR15145662.*.fq.gz 
multiqc --force -o ${dir9} -n CORRECTION_fastqc_summary -i CORRECTION_fastqc_summary ${dir9}

## QC assembled fastq files    
# run renaming script before QC
dir10="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
ASSEM_DIR=(${dir10}/*_SPADessembly)
# ASSEM_QC_DIR=$(basename ${ASSEM_DIR[@]} "_SPADessembly")
dir11="${dir1}/ASSEMBLY_fastqc"    
fastqc --memory 10GB -f fastq -t 4 -noextract -o $dir11 ${ASSEM_DIR[@]}/SRR15145662_contigs.fasta 
multiqc -o ${dir11} -n ASSEMBLY_fastqc_summary ${dir11}

## exit


echo "END TIME": '' $(date)
###