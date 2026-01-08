#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBmap
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DNB_3_2_BBmap_proks_bp2.out
#SBATCH --error=DNB_3_2_BBmap_proks_bp2.err
#SBATCH --mail-user=slee@geomar.de
#SBATCH --mail-type=ALL
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
EC_READ_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_DAVID/ERROR_CORRECTED_RENAMED"
MAPPED_PROKS_CTG_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/MAPPED_PROKS_CTG"
mkdir -p ${MAPPED_PROKS_CTG_DIR}

cd $MAPPED_PROKS_CTG_DIR

echo starting bbmap for proks_bp at $(date)
for sample in ${EC_READ_DIR}/*.qc.ec.PE.fq.gz;
do
    base=$(basename $sample ".qc.ec.PE.fq.gz")
    if [ ! -f ${MAPPED_PROKS_CTG_DIR}/${base}.EC_Proks_mapped.fq.gz ]; then
        echo working on $sample 
        bbmap.sh \
            ref=${PROKS_DIR}/${base}_ctg_Proks.fna \
            in=${EC_READ_DIR}/${base}.qc.ec.PE.fq.gz \
            outm=${MAPPED_PROKS_CTG_DIR}/${base}.EC_Proks_mapped.fq.gz \
            threads=16 pairedonly=t pigz=t \
            printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t tossbrokenreads=t; 
        echo .mapped.fq.gz file for $base is now has been created
    elif [ -f ${MAPPED_PROKS_CTG_DIR}/${base}.EC_Proks_mapped.fq.gz ]; then
        echo "mapped.fq.gz file $sample already exist"
    else
        echo "mapped.fq file $sample: something went wrong"
    fi
done

echo "END TIME": '' $(date)
##