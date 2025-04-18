#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DMC2
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Assembly_all_p2.out
#SBATCH --error=Assembly_all_p2.err
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass
CONTIGsDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
OUTPUTDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass"

echo "START TIME": '' $(date)
for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed/*_contigs_min500_renamed.fasta;do 
    file=$(basename $i)
    base=$(basename $i "_contigs_min500_renamed.fasta")

    if [ ! -f ${OUTPUTDir}/${base}_*.tsv ];then 
        echo working with $i
        DeepMicroClass predict --input $i --output_dir ${OUTPUTDir}/ --encoding onehot --mode hybrid --device cpu    
    else
        echo "File ${OUTPUTDir}/${file} already exists"
    fi
done

echo "END TIME": '' $(date)
##
