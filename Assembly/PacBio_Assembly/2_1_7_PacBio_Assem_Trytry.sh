#!/bin/bash
#SBATCH -c 12
#SBATCH --job-name=PB_ASSEM
#SBATCH -t 10-00:00
#SBATCH --qos=long
#SBATCH -p base
#SBATCH --mem=200G
#SBATCH --output=PacBio_assem_Trycycler.out
#SBATCH --error=PacBio_assem_Trycycler.err

# Load modules
cd /gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate trycycler
module load singularity/3.11.5

# Start logging
echo "START TIME: $(date)"

# Set up paths
Trycycler_DIR="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler"
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"
FILES=($PacBio_RAW/*_1.fastq.gz)

for fastq_file in "${FILES[@]}"; do
    cd /gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Trycycler
    base=$(basename "$fastq_file" "_1.fastq.gz")

    # Create directories
    mkdir -p "${Trycycler_DIR}/${base}/${base}_read_subsets"
    mkdir -p "${Trycycler_DIR}/${base}/${base}_assemblies"

    sampleDIR="${Trycycler_DIR}/${base}/${base}_read_subsets"
    assemDIR="${Trycycler_DIR}/${base}/${base}_assemblies"

## Step 1: Subsampling PacBio reads
#     jid1=$(sbatch --parsable --cpus-per-task=4 --mem=200G --time=2-00:00 <<EOF
# #!/bin/bash
# trycycler subsample --reads "$fastq_file" --out_dir "$sampleDIR" --threads 16 --count 16
# EOF
#     )

    # Step 2: Assembly using multiple assemblers    
    # if using subsample first, add --dependency=afterok:$jid1 to the sbatch commands below

    # Flye assembler
    #mkdir -p "${assemDIR}/FLYE_assemblies"
    for i in 01 05 09 13; do
        sbatch --cpus-per-task=4 --mem=200G --time=2-00:00 <<EOF
#!/bin/bash
flye --pacbio-raw "$sampleDIR/sample_${i}.fastq" --out-dir "$assemDIR/FLYE_assemblies/${base}" -t 8 --meta
EOF
    done

    # Miniasm + Minipolish assembler
    #mkdir -p "${assemDIR}/MM_assemblies"
    for i in 02 06 10 14; do
        sbatch --cpus-per-task=4 --mem=200G --time=2-00:00 <<EOF
#!/bin/bash
miniasm_and_minipolish.sh "$sampleDIR/sample_${i}.fastq" 8 > "$assemDIR/MM_assemblies/assembly_${i}.gfa"
any2fasta "$assemDIR/MM_assemblies/assembly_${i}.gfa" > "$assemDIR/MM_assemblies/assembly_${i}.fasta"
EOF
    done

#     # Raven assembler
#     mkdir -p "${assemDIR}/RAVEN_assemblies"
#     for i in 03 07 11 15; do
#         sbatch --dependency=afterok:$jid1 --cpus-per-task=4 --mem=200G --time=2-00:00 <<EOF
# #!/bin/bash
# raven --threads 8 --disable-checkpoints --graphical-fragment-assembly "$assemDIR/RAVEN_assemblies/assembly_${i}.gfa" "$sampleDIR/sample_${i}.fastq" > "$assemDIR/RAVEN_assemblies/assembly_${i}.fasta"
# EOF
#     done

    # FALCON assembler of PacBio
    mkdir -p "${assemDIR}/FALCON_assemblies"
    cd ${sampleDIR}/
    cat > ${base}_fc_run.cfg 
    for i in 04 08 12 16; do
    echo "${sampleDIR}/sample_${i}.fastq" >> ${base}_fc_run.cfg
    done

    jid2=$(sbatch --cpus-per-task=4 --mem=200G --time=2-00:00 --wrap="fc_run ${sampleDIR}/${base}_fc_run.cfg")


    cat > ${assemDIR}/FALCON_assemblies/${base}_fc_unzip.cfg
    for i in 04 08 12 16; do
    echo "${assemDIR}/FALCON_assemblies/assembly_${i}.fastq" >> ${base}_fc_run.cfg
    done
    sbatch --dependency=afterok:$jid2 --cpus-per-task=4 --mem=200G --time=2-00:00 --wrap="fc_unzip.py ${assemDIR}/FALCON_assemblies/${base}_fc_unzip.cfg"
done

echo "END TIME: $(date)"

##