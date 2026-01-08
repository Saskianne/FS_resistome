#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBMap_SortBAM
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_3_1_BBmap_SortBAM1.out
#SBATCH --error=DNB_3_1_BBmap_SortBAM1.err
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
DMC_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/DeepMicroClass"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
ProdDIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO/PRODIGAL"
EC_READ_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ERROR_CORRECTED_RENAMED"
MAP_DIR="${metaWGS_SUNWOO_DIR}/MAPPING"
mkdir -p ${MAP_DIR}
BAM_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/BAM_FILEs"
mkdir -p ${BAM_DIR}
SORTED_BAM_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/SORTED_BAM_FILEs"
mkdir -p ${SORTED_BAM_DIR}
COV_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/COVERAGE"
mkdir -p ${COV_DIR}


cd $BAM_DIR

echo starting bbmap at $(date)
for sample in ${EC_READ_DIR}/*.qc.ec.PE.fq.gz;
do
    base=$(basename $sample ".qc.ec.PE.fq.gz")
    if [ ! -f ${BAM_DIR}/${base}.out.bam ]; then
        echo working on $sample 
        bbmap.sh \
            ref=${PROKS_DIR}/${base}_ctg_Proks.fna \
            in=${EC_READ_DIR}/${base}.qc.ec.PE.fq.gz \
            out=${BAM_DIR}/${base}.out.bam \
            threads=16 pairedonly=t pigz=t \
            printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t bamscript=bs.sh; sh bs.sh; 
        echo .bam file for $base is now has been created
    else
        echo "BAM file $sample already exist"
    fi
done

echo bbmap completed at $(date)
echo starting with samtools sort at $(date)

for sample in ${BAM_DIR}/*.out.bam;
do
base=$(basename $sample ".out.bam")
if [ ! -f ${BAM_DIR}/${base}.out.sorted.bam ]; then
    echo working on $base
    samtools sort \
        -o ${BAM_DIR}/${base}.out.sorted.bam \
        --output-fmt BAM \
        --threads 16 \
        --reference ${PROKS_DIR}/${base}_ctg_Proks.fna \
        $sample; 
    echo .sorted.bam file for $base is now has been created
else
    echo "BAM file $sample already exist"
fi
done

echo samtools sort completed at $(date)
echo start regenarating coverage file at $(date)

conda activate METABAT2

for sample in ${BAM_DIR}/*.out.sorted.bam;
do
if [ ! -f ${COV_DIR}/${base}.depth.txt ]; then
    base=$(basename $sample ".out.sorted.bam")
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_DIR}/${base}.depth.txt \
        --pairedContigs ${COV_DIR}/${base}.paired.txt \
        ${SORTED_BAM_DIR}/${base}.out_sorted.bam \
        --referenceFasta ${PROKS_DIR}/${base}_ctg_Proks.fna; 
    echo .depth.txt file for $base is now has been created
else
    echo "depth.txt file for $sample already exist"
fi
done

echo "END TIME": '' $(date)
##