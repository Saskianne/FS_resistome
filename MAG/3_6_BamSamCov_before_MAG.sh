#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBMap_SortBAM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=220G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BBmap_SortBAM2.out
#SBATCH --error=BBmap_SortBAM2.err
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs


PROK_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
EC_READs="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs"

echo starting bbmap at $(date)
for sample in ${EC_READs}/*.qc.ec.PE.fq.gz;
do
    base=$(basename $sample ".qc.ec.PE.fq.gz")
    if [ ! -f ${BAM_FILEs}/${base}.out.bam ]; then
        echo working on $sample 
        bbmap.sh \
            ref=${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
            in=${EC_READs}/${base}.qc.ec.PE.fq.gz \
            out=${BAM_FILEs}/${base}.out.bam \
            threads=16 pairedonly=t pigz=t \
            printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t bamscript=bs.sh; sh bs.sh; 
        echo .bam file for $base is now has been created
    else
        echo "BAM file $sample already exist"
    fi
done

echo bbmap completed at $(date)
echo starting with samtools sort at $(date)

for sample in ${BAM_FILEs}/*.out.bam;
do
base=$(basename $sample ".out.bam")
if [ ! -f ${BAM_FILEs}/${base}.out.sorted.bam ]; then
    echo working on $base
    samtools sort \
        -o ${BAM_FILEs}/${base}.out.sorted.bam \
        --output-fmt BAM \
        --threads 16 \
        --reference ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
        $sample; 
    echo .sorted.bam file for $base is now has been created
else
    echo "BAM file $sample already exist"
fi
done

echo samtools sort completed at $(date)
echo start regenarating coverage file at $(date)

conda activate MAG

COV_Files="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/COVERAGE_FILEs"
for sample in ${BAM_FILEs}/*.out_sorted.bam;
do
if [ ! -f ${COV_Files}/${base}.depth.txt ]; then
    base=$(basename $sample ".out.sorted.bam")
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_Files}/${base}.depth.txt \
        --pairedContigs ${COV_Files}/${base}.paired.txt \
        ${BAM_FILEs}/${base}.out.sorted.bam \
        --referenceFasta ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna; 
    echo .depth.txt file for $base is now has been created
else
    echo "depth.txt file for $sample already exist"
fi
done

echo "END TIME": '' $(date)
##