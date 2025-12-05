#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Trim
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_1_2_Trimmomatic.out
#SBATCH --error=DNB_1_2_Trimmomatic.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/QCed_DATA
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

echo "START TIME": '' $(date)

# Set up variables
cd /gxfs_work/geomar/smomw681/BGI_META_WGS_DATA
WGS_RAW_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA"
metaWGS_FILES="$WGS_RAW_DIR/BGI_DATA_OCT21_2025/*/*.fq.gz"
DB_DIR="/gxfs_work/geomar/smomw681/DATABASES/"

# iterate over fastq files
for fastq_file in "${FILES[@]}"; do
     base=$(basename $fastq_file "_1.fastq.gz")
     sbatch --cpus-per-task=4 --mem=80G --time 2-00:00 --wrap="trimmomatic PE -threads 4 -phred33 \
          ${dir5}/${base}_1.fastq.gz ${dir5}/${base}_2.fastq.gz \
          ${dir4}/${base}.qc.pe.R1.fq.gz ${dir4}/${base}.qc.se.R1.fq.gz \
          ${dir4}/${base}.qc.pe.R2.fq.gz ${dir4}/${base}.qc.se.R2.fq.gz \
          ILLUMINACLIP:${DB_DIR}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40" 
          # ILLUMINACLIP: cut adapter and other illumina-specific seq from the read
          # LEADING: Cut bases off the start of a read, if below a threshold quality
          # TRAILING: Cut bases off the end of a read, if below a threshold quality
          # SLIDINGWINDOW: Performs a sliding window trimming approach. It starts scanning at the 5‟ end and clips the read once the average quality within the window falls below a threshold.
          # MINLEN: drop the read if it is below a specified length
          # -phred33 convert quality score to Phred-33
done

echo "END TIME": '' $(date)

#