#!/bin/bash
#SBATCH -c 28                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Tad1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=250G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Tadpole2.logout
#SBATCH --error=Tadpole2.err
#
echo "START TIME: $(date)"

# Load modules or resources
#module load gcc12-env/12.3.0
#module load miniconda3/24.11.1
#module load miniconda3/23.5.2
#conda activate AVIARY

# Set proxy if needed
export http_proxy=http://10.0.7.235:3128
export https_proxy=http://10.0.7.235:3128

# Set up variables
dir1="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/PHIX_FILTERED"
dir2="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/ERROR_CORRECTED"
FILES=($dir1/*.qc.PE.unmapped.fq.gz)

# Iterate through files in batches of 3
for (( i=0; i<${#FILES[@]}; i+=3 )); do
batch=("${FILES[@]:i:3}")
for file in "${batch[@]}"; do
base=$(basename $file ".qc.PE.unmapped.fq.gz")
sbatch --cpus-per-task=2 --mem=80G --wrap="tadpole.sh \
in=${dir1}/${base}.qc.PE.unmapped.fq.gz \
out=${dir2}/${base}.qc.ec.PE.fq.gz \
threads=8 ecc=t rollback=t pincer=t tail=t prefilter=t prealloc=t mode=correct tossbrokenreads=t"
done
done

echo "END TIME: $(date)"
#
