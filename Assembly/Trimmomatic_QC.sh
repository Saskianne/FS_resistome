#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Trm1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=250G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Trim_output.out
#SBATCH --error=Trim_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

# Set up variables
dir3="/gxfs_work/geomar/smomw681/DATABASES/Adapters"
dir4="/gxfs_work/geomar/smomw681/DATA"
dir5="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/RAW_DATA"
FILES=($dir5/*_1.fastq.gz)

# Iterate through files in batches of 3
for (( i=0; i<${#FILES[@]}; i+=3 )); do
batch=("${FILES[@]:i:3}")
for file in "${batch[@]}"; do
base=$(basename $file "_1.fastq.gz")
sbatch --cpus-per-task=2 --mem=80G --wrap="trimmomatic PE -threads 4 -phred33 \
     ${dir5}/${base}_1.fastq.gz ${dir5}/${base}_2.fastq.gz \
     ${dir4}/${base}.qc.pe.R1.fq.gz ${dir4}/${base}.qc.se.R1.fq.gz \
     ${dir4}/${base}.qc.pe.R2.fq.gz ${dir4}/${base}.qc.se.R2.fq.gz \
     ILLUMINACLIP:${dir3}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40"
done
done

echo "END TIME": '' 'date'
#