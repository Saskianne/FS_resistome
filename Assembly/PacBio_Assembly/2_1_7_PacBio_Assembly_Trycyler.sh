#!/bin/bash
#SBATCH -c 12                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_assem_Trycyler.out
#SBATCH --error=PacBio_assem_Trycyler.err

# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/Trycyler
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate trycycler
module load singularity/3.11.5

# download PacBio SMRT link to use the pipelines

echo "START TIME": '' $(date)

# Set up variables

Trycyler_DIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycyler"
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($dir5/*_1.fastq.gz)

mkdir read_subsets
sampleDIR="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/Trycyler/read_subsets"
mkdir assemblies 
assemDIR="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/Trycyler/assemblies"

for fastq_file in "${FILES[@]}"; do
     base=$(basename $fastq_file "_1.fastq.gz")
     mkdir ${sampleDIR}/${base}
     # Subsample QCed long-reads, iterate over fastq files
     jid1=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --wrap= \
          "tryclyer subsample --reads ${FILES} -out_dir ${Trycycler_DIR}/read_subsets --threads 16 --count 16")
     # Output files: read_subsets/sample_*.fastq

     # Run assembly pipelines, dependency on subsampling job
     mkdir 
     for i in 01 05 09 13; do
          jid2=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "flye --pacbio-raw ${sampleDIR}/${base}/sample_"$i".fastq --out-dir ${sampleDIR}/${base} -t 8 --meta")
     done
     for i in 02 06 10 14; do
          jid3=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "miniasm_and_minipolish.sh ${sampleDir}/${base}/sample_02.fastq --threads 8 > assemblies/assembly_02.gfa && any2fasta assemblies/assembly_02.gfa > assemblies/assembly_02.fasta")
     
     done
     for i in 03 07 11 15; do
          jid4=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "raven --threads 8 --disable-checkpoints --graphical-fragment-assembly assemblies/assembly_03.gfa ${sampleDIR}/${base}/sample_03.fastq > assemblies/assembly_03.fasta")
     done

done



trycycler 

echo "END TIME": '' $(date)
##