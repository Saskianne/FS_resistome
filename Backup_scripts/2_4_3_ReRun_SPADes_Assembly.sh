#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Spd2
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SPADEs4_logouput.out
#SBATCH --error=SPADEs4_run_errors.err
# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate Assembly

echo "START TIME": '' $(date)

# Set up variables
READS_DIR="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
ASSEMBLY_DIR="/gxfs_work/geomar/smomw681/DATA/ASSEMBLIES"

FILES=("SRR15145662.qc.ec.PE.fq.gz" "SRR15145666.qc.ec.PE.fq.gz")
base=("${READS_DIR}/SRR15145662" "${READS_DIR}/SRR15145666")

echo start to run SPAdes assembly
spade() {
    echo start to run SPAdes assembly
    spades.py -t 8 --memory 50 -k 21,33,55,71,99,113,127 --meta --only-assembler --12 $1.qc.ec.PE.fq.gz -o $1_SPADessembly
    echo finish SPAdes assembly
}
export -f spade
parallel spade ::: ${base}
# End the job
echo "END TIME": '' $(date)
#