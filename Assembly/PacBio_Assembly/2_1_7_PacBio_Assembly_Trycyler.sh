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
cd /gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycyler
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate trycycler
module load singularity/3.11.5

# download PacBio SMRT link to use the pipelines

echo "START TIME": '' $(date)

# Set up variables

Trycycler_DIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler"
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($PacBio_RAW/*_1.fastq.gz)

for fastq_file in "${FILES[@]}"; do
     base=$(basename $fastq_file "_1.fastq.gz")
     mkdir ${Trycycler_DIR}/${base}
     mkdir ${Trycycler_DIR}/${base}/"${base}"_read_subsets
     sampleDIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler/${base}/${base}_read_subsets"
     mkdir ${Trycycler_DIR}/${base}/"${base}"_assemblies 
     assemDIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler/${base}/${base}_assemblies"

     # Subsample QCed long-reads, iterate over fastq files
     jid1=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --wrap= \
          "trycycler subsample --reads $fastq_file -out_dir ${sampleDIR} --threads 16 --count 16")
     # Output files: read_subsets/sample_*.fastq

     # Run assembly pipelines, dependency on subsampling job
     mkdir ${assemDIR}/FLYE_assemblies
     for i in 01 05 09 13; do
          jid2=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "flye --pacbio-raw ${sampleDIR}/sample_"$i".fastq --out-dir ${assemDIR}/FLYE_assemblies/${base} -t 8 --meta")
     done

     mkdir ${assemDIR}/MM_assemblies
     for i in 02 06 10 14; do
          jid3=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "miniasm_and_minipolish.sh ${sampleDir}/sample_"$i".fastq --threads 8 > ${assemDIR}/MM_assemblies/assembly_"$i".gfa && any2fasta ${assemDIR}/MM_assemblies/assembly_"$i".gfa > ${assemDIR}/MM_assemblies/assembly_"$i".fasta")
     done

     mkdir ${assemDIR}/RAVEN_assemblies
     for i in 03 07 11 15; do
          jid4=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "raven --threads 8 --disable-checkpoints --graphical-fragment-assembly ${assemDIR}/RAVEN_assemblies/assembly_"$i".gfa ${sampleDIR}/sample_"$i".fastq > ${assemDIR}/RAVEN_assemblies/assembly_"$i".fasta")
     done

     mkdir ${assemDIR}/HIFIASM_meta_assemblies
     for i in 04 08 12 16; do
          jid5=$(sbatch --cpus-per-task=4 --mem=200G --time 2-00:00 --dependency=afterok:$jid1 --wrap= \
               "hifiasm_meta -o ${assemDIR}/HIFIASM_meta_assemblies/assembly_"$i" -t 8 ${sampleDIR}/sample_"$i".fastq 2>${assemDIR}/HIFIASM_meta_assemblies/assembly_"$i".log")
     done
          # Contig graph: asm.p_ctg*.gfa and asm.a_ctg*.gfa
          # Raw unitig graph: asm.r_utg*.gfa
          # Cleaned unitig graph: asm.p_utg*.gfa
done


echo "END TIME": '' $(date)
# erase all the sampling files afterwards
# rm -r read_subsets
##