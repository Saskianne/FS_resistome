#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Spd2
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=240G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SPADEs3_logouput.out
#SBATCH --error=SPADEs3_run_errors.err
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
FILES=($READS_DIR/SRR15145660.qc.ec.PE.fq.gz $READS_DIR/SRR15145661.qc.ec.PE.fq.gz $READS_DIR/SRR15145662.qc.ec.PE.fq.gz $READS_DIR/SRR15145663.qc.ec.PE.fq.gz $READS_DIR/SRR15145664.qc.ec.PE.fq.gz $READS_DIR/SRR15145666.qc.ec.PE.fq.gz $READS_DIR/SRR23378604.qc.ec.PE.fq.gz $READS_DIR/SRR23378605.qc.ec.PE.fq.gz, $READS_DIR/SRR6667231.qc.ec.PE.fq.gz)

# Iterate through files in batches of 2
for file in "${FILES[@]}"
    do
        echo Start the assembly for $file at $(date)
        base=$(basename $file ".qc.ec.PE.fq.gz")

        # Get the file size in GB
        filesize_gb=$(du -sBG "$file" | cut -f1 | sed 's/G//')
        
        # Set memory per CPU based on file size
        if [[ $filesize_gb -lt 50 ]]; then
            mem_per_cpu="18G"
            cpus=8
        else
            mem_per_cpu="44G"
            cpus=8
        fi

        # Submit the SPAdes job with the calculated memory and CPUs
        sbatch --cpus-per-task=$cpus --mem-per-cpu=$mem_per_cpu -t 2-00:00 --wrap="spades.py -t $cpus -m $(( ${mem_per_cpu%G} * cpus )) -k 21,33,55,71,99,113,127 --meta --only-assembler --12 ${READS_DIR}/${base}.qc.ec.PE.fq.gz -o ${ASSEMBLY_DIR}/${base}_SPADessembly"
        echo The SPAdes assembly batch for $file submitted at $(date)
    done

# End the job
echo "END TIME": '' $(date)
#