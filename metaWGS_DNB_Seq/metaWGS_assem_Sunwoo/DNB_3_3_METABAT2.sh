#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=MetaBat2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=metaBAT2_PROKS_MAGs.out
#SBATCH --error=metaBAT2_PROKS_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate METABAT2
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2

metaWGS_SUNWOO_DIR="/gxfs_work/geomar/smomw681/BGI_META_WGS_DATA/BGI_DATA_SUNWOO"
PROKS_DIR="${DMC_DIR}/PROKS_CONTIGs"
MAPPED_PROKS_CTG_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/MAPPED_PROKS_CTG"
MAP_DIR="${metaWGS_SUNWOO_DIR}/MAPPING"
BAM_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/BAM_FILEs"
COV_DIR="${metaWGS_SUNWOO_DIR}/MAPPING/COVERAGE"
METABAT2_DIR="${metaWGS_SUNWOO_DIR}/METABAT2_PROKSBIN"
mkdir -p ${METABAT2_DIR}

echo "START TIME": '' $(date)
echo start metabat2 binning for PROKS contigs

for sample in ${PROKS_DIR}/*_ctg_Proks.fna; do
     echo "Start processing sample: $sample at \n $(date)"
     start_time=$(date +%s)
     base=$(basename $sample "_ctg_Proks.fna") # check whether the input file is correct
     if [ ! -f ${METABAT2_FILEs}/${base}.metabat2.proksbin.* ]; then
     metabat2 -t 6 -m 1500 \
          -a ${COV_DIR}/${base}.depth.txt \
          -o ${METABAT2_DIR}/${base}.metabat2.proksbin.fasta \
          -i $sample  
     echo "Finish processing sample: $sample at \n $(date)"
     end_time=$(date +%s)
     job_time=$(((end_time - start_time)/60))
     echo "It took $job_time minutes or $((jobtime / 60)) to process sample: $sample";
     elif [ -f ${METABAT2_DIR}/${base}.metabat2.proksbin.* ]; then 
          echo "File exists: ${base}.metabat2.proksbin";
     else
          echo Something went wrong. 
fi     
done

echo "END TIME": '' $(date)
##
