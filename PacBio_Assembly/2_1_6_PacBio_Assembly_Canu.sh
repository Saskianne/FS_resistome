#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem.out
#SBATCH --error=PacBio_assem_err.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate PacBio_Assembly

echo "START TIME": '' $(date)

# Set up variables

dir4="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"
dir5="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($dir5/*_1.fastq.gz)

# iterate over fastq files
for fastq_file in "${FILES[@]}"; do
    
     base=$(basename $fastq_file "_1.fastq.gz")
     sbatch --cpus-per-task=2 --mem=80G --time 5-00:00 --wrap="trimmomatic PE -threads 4 -phred33 \
          ${dir5}/${base}_1.fastq.gz ${dir5}/${base}_2.fastq.gz \
          ${dir4}/${base}.qc.pe.R1.fq.gz ${dir4}/${base}.qc.se.R1.fq.gz \
          ${dir4}/${base}.qc.pe.R2.fq.gz ${dir4}/${base}.qc.se.R2.fq.gz \
          ILLUMINACLIP:${dir3}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40"
done

echo "END TIME": '' $(date)
##