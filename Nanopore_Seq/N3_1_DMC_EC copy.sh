#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=DMC
#SBATCH -t 6-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=N3_1_DMC_EC.out
#SBATCH --error=N3_1_DMC_EC.err
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass

echo "START TIME": '' $(date)

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed/*_contigs_min500_renamed.fasta;
do
echo working with $i
CONTIGsDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"; 
base=$(basename $i "_min500bp.fasta");
OUTPUTDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass"
DeepMicroClass predict \
     --input $i \
     --output_dir ${OUTPUTDir}/ \
     --encoding onehot \
     --mode hybrid \
     --device cpu; 
    done
echo "END TIME": '' 'date'
##