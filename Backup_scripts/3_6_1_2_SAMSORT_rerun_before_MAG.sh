#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBMap_SortBAM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=JGI_Co3.out
#SBATCH --error=JGI_Cov3.err
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs


PROK_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs"
RERUN_SAMSORT="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs/RERUN_SAMSORT"
Calmd_BAM="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs/Calmd_BAM"
COV_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/COVERAGE_FILEs"

echo starting with samtools sort at $(date)

# for sample in ${BAM_FILEs}/*.out.bam;
# do
# base=$(basename $sample ".out.bam")
# if [ ! -f ${RERUN_SAMSORT}/${base}.out.sorted.bam ]; then
#     echo working on $base
#     samtools sort \
#         -o ${RERUN_SAMSORT}/${base}.out.sorted.bam \
#         --output-fmt BAM \
#         --threads 16 \
#         --reference ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
#         $sample; 
#     echo .sorted.bam file for $base is now has been created
# else
#     echo "BAM file $sample already exist"
# fi
# done

# echo samtools sort completed at $(date)

conda activate MAG
echo start regenarating coverage file at $(date)

COV_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/COVERAGE_FILEs"
for sample in ${RERUN_SAMSORT}/*.out.sorted.bam;
do
if [ ! -f ${COV_Files}/${base}.depth.txt ]; then
    base=$(basename $sample ".out.sorted.bam")
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_Files}/${base}.depth.txt \
        --pairedContigs ${COV_Files}/${base}.paired.txt \
        ${RERUN_SAMSORT}/${base}.out.sorted.bam \
        --referenceFasta ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna; 
    echo .depth.txt file for $base is now has been created
else
    echo "depth.txt file for $sample already exist"
fi
done

echo "END TIME": '' $(date)
##