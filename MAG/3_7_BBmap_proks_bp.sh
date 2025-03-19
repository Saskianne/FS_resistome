#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=BBmap
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=200G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=BBmap_proks_bp2.out
#SBATCH --error=BBmap_proks_bp2.err
#SBATCH --mail-user=slee@geomar.de
#SBATCH --mail-type=ALL
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)

cd /gxfs_work/geomar/smomw681/DATA
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

PROK_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
EC_READs="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
Proks_mapped="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PROKS_mapped"

echo starting bbmap for proks_bp at $(date)
for sample in ${EC_READs}/*.qc.ec.PE.fq.gz;
do
    base=$(basename $sample ".qc.ec.PE.fq.gz")
    if [ ! -f ${Proks_mapped}/${base}.EC_Proks_mapped.fq.gz ]; then
        echo working on $sample 
        bbmap.sh \
            ref=${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
            in=${EC_READs}/${base}.qc.ec.PE.fq.gz \
            outm=${Proks_mapped}/${base}.EC_Proks_mapped.fq.gz \
            threads=16 pairedonly=t pigz=t \
            printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t tossbrokenreads=t; 
        echo .mapped.fq.gz file for $base is now has been created
    elif [ -f ${Proks_mapped}/${base}.EC_Proks_mapped.fq.gz ]; then
        echo "mapped.fq.gz file $sample already exist"
    else
        echo "mapped.fq file $sample: something went wrong"
    fi
done

echo "END TIME": '' $(date)
##