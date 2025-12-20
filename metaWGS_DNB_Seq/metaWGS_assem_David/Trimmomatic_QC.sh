#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Trm1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=250G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Trim_output.out
#SBATCH --error=Trim_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME: $(date)"

# Load modules or resources
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
#module load miniconda3/23.5.2
#conda activate AVIARY

# Set proxy if needed
export http_proxy=http://10.0.7.235:3128
export https_proxy=http://10.0.7.235:3128

# Set up variables
dir3="/gxfs_work/geomar/smomw647/DATABASES/Adapters"
dir4="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/QCed_DATA"
dir5="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/RAWDATA"
FILES=($dir5/*_1.fq.gz)

# Iterate through files in batches of 3
for (( i=0; i<${#FILES[@]}; i+=3 )); do
batch=("${FILES[@]:i:3}")
for file in "${batch[@]}"; do
base=$(basename $file "_1.fq.gz")
sbatch --cpus-per-task=2 --mem=80G --wrap="trimmomatic PE -threads 4 -phred33 \
     ${dir5}/${base}_1.fq.gz ${dir5}/${base}_2.fq.gz \
     ${dir4}/${base}.qc.pe.R1.fq.gz ${dir4}/${base}.qc.se.R1.fq.gz \
     ${dir4}/${base}.qc.pe.R2.fq.gz ${dir4}/${base}.qc.se.R2.fq.gz \
     ILLUMINACLIP:${dir3}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40"
done
done

echo "END TIME: $(date)"
#
