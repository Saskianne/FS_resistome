#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Trm1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Trim_output_1.out
#SBATCH --error=Trim_run_errors_1.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

echo "START TIME": '' $(date)

# Set up variables
dir3="/gxfs_work/geomar/smomw681/DATABASES/"
dir4="/gxfs_work/geomar/smomw681/DATA/QCed_DATA"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA"


# FILES=(SRR15145662, SRR15145663, SRR15145664, SRR15145666)

# iterate over fastq files
cat FILES | parallel -j 4 "base=$(basename {} "_1.fastq.gz"); \
     trimmomatic PE -threads 8 -phred33 \
          ${dir5}/${}_1.fastq.gz ${dir5}/${.}_2.fastq.gz \
          ${dir4}/${.}.qc.pe.R1.fq.gz ${dir4}/${.}.qc.se.R1.fq.gz \
          ${dir4}/${.}.qc.pe.R2.fq.gz ${dir4}/${.}.qc.se.R2.fq.gz \
          ILLUMINACLIP:${dir3}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40"


echo "END TIME": '' $(date)

#