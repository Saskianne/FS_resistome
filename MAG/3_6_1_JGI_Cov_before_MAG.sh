#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBMap_SortBAM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=JGI_Cov1.out
#SBATCH --error=JGI_Cov1.err
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs


PROK_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs"
Calmd_BAM="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs/Calmd_BAM"
COV_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/COVERAGE_FILEs"

conda activate Assembly
for sample in ${BAM_FILEs}/*.out.sorted.bam;
do
base=$(basename $sample ".out.sorted.bam")
if [ ! -f ${Calmd_BAM}/${base}.out.sorted.calmd.bam ]; then
    samtools calmd -b ${BAM_FILEs}/${base}.out.sorted.bam ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna > ${Calmd_BAM}/${base}.out.sorted.calmd.bam
    samtools index ${Calmd_BAM}/${base}.out.sorted.calmd.bam
    echo .calmd.bam file for $base is now has been created
elif [ -f ${Calmd_BAM}/${base}.out.sorted.calmd.bam ]; then
    echo ".calmd.bam file for $sample already exist"
else
    echo something is wrong here
fi
done

conda activate MAG
for sample in ${Calmd_BAM}/*.out.sorted.calmd.bam;
do
base=$(basename $sample ".out.sorted.calmd.bam")
if [ ! -f ${COV_Files}/${base}.depth.txt ]; then
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_Files}/${base}.depth.txt \
        --pairedContigs ${COV_Files}/${base}.paired.txt \
        ${Calmd_BAM}/${base}.out.sorted.calmd.bam \
        --referenceFasta ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna; 
    echo .depth.txt file for $base is now has been created
elif [ -f ${COV_Files}/${base}.depth.txt ]; then
    echo "depth.txt file for $sample already exist"
else
    echo something is wrong here
fi
done

echo "END TIME": '' $(date)
##