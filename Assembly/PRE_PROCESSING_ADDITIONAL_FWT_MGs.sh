## ANALYZE 
### OTHER FRESHWATER METAGENOMEs
## MIGHT IMPORTANT FOR MACHINE LEARNING

## use parallel to  download multiple samples
## January 31, 2025
## fastq-dump : 3.1.1

conda create -n SRA_Tools
conda activate SRA_Tools
conda install -c bioconda sra-tools parallel-fastq-dump

#usage: parallel-fastq-dump [-h] [-s SRA_ID] [-t THREADS] [-O OUTDIR] [-T TMPDIR] [-N MINSPOTID] [-X MAXSPOTID] [-V]


##################################################
## DATA 1
##################################################
## Rhower et al. 2025
## 381 additional metagenomes not previously covered
##################################################
cd /gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/LAKE_MENDOTA

export http_proxy=http://10.0.7.235:3128
sbatch -p base -c 3 --mem=50G --mail-type=END --mail-user=dngugi@geomar.de --job-name=SRR3 --wrap="fastq-dump \
     --outdir /gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/RAW_DATA/ \
     --gzip \
     --split-files SRR27983508"
#

cat > Run_fastqDump_LMend381.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SRR1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=LMend381MGs_log.out
#SBATCH --error=LMend381MGs_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
export http_proxy=http://10.0.7.235:3128
for i in $(cat TO_do_LIST.txt)
do
dir1="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/LAKE_MENDOTA/RAW_DATA"
     echo working with $i
     newfile="$(basename $i .fastq.gz)"
     parallel -j 16 fastq-dump --outdir ${dir1}/ --gzip --split-files {} ::: $i; 
     done
echo "END TIME": '' 'date'
##

##################################################
## DATA 2 Lake Victoria, Naivasha
##################################################
## XXXX et al. 2024 {PRJNA1119566}
## 48 additional metagenomes not previously covered
##################################################
cd /gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/LAKE_VICTORIA


cat > Run_fastqDump_LVictoria49.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SRR2
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=LVic49MGs_log.out
#SBATCH --error=LVic49MGs_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
export http_proxy=http://10.0.7.235:3128
for i in $(cat SRR_LIST.txt)
do
dir1="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/LAKE_VICTORIA/RAW_DATA"
     echo working with $i
     newfile="$(basename $i .fastq.gz)"
     parallel -j 16 fastq-dump --outdir ${dir1}/ --gzip --split-files {} ::: $i; 
     done
echo "END TIME": '' 'date'
##

##################################################
## DATA 3 South African Lakes
##################################################
## Ijoma et al. 2023 {PRJNA1022586}
## 46 additional metagenomes not previously covered
##################################################
cd /gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES


cat > Run_fastqDump_SouthAfrica46.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SRR3
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SA46MGs_log.out
#SBATCH --error=SA46MGs_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
export http_proxy=http://10.0.7.235:3128
for i in $(cat SRR_LIST.txt)
do
dir1="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/RAW_DATA"
     echo working with $i
     newfile="$(basename $i .fastq.gz)"
     parallel -j 16 fastq-dump --outdir ${dir1}/ --gzip --split-files {} ::: $i; 
     done
echo "END TIME": '' 'date'
##


###################################################
### Step 2 
## Remove PhixReads MGs
##
cd 
mkdir QCed_DATA PHIX_FILTERED ERROCORRECTED ASSEMBLIES

### In batch

cat > Trimmomatic_QC.sh

#!/bin/bash
#SBATCH -c 32                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Trm1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=250G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Trim_output.out
#SBATCH --error=Trim_run_errors.err

# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
dir3="/gxfs_work/geomar/smomw647/DATABASES/Adapters"
dir4="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/QCed_DATA"
dir5="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/RAW_DATA"
FILES=($dir5/*_1.fastq.gz)

# Iterate through files in batches of 3
for (( i=0; i<${#FILES[@]}; i+=3 )); do
batch=("${FILES[@]:i:3}")
for file in "${batch[@]}"; do
base=$(basename $file "_1.fastq.gz")
sbatch --cpus-per-task=2 --mem=80G --wrap="trimmomatic PE -threads 4 -phred33 \
     ${dir5}/${base}_1.fastq.gz ${dir5}/${base}_2.fastq.gz \
     ${dir4}/${base}.qc.pe.R1.fq.gz ${dir4}/${base}.qc.se.R1.fq.gz \
     ${dir4}/${base}.qc.pe.R2.fq.gz ${dir4}/${base}.qc.se.R2.fq.gz \
     ILLUMINACLIP:${dir3}/Complete_Adapter_Primer_info.fa:4:30:10 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:20 MINLEN:40"
done
done

echo "END TIME": '' 'date'
#


### Step 3 
## Remove PhixReads MGs
##
cat > Phix174_removal.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PhIX1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PHIX1_FILTERED_ouputlog.out
#SBATCH --error=PHIX1_FILTERED_errors.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for sample in `ls /gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/QCed_DATA/*.qc.pe.R1.fq.gz`;
do
dir1="/gxfs_work/geomar/smomw647/DATABASES/CONTAMINANTs"
dir2="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/QCed_DATA"; base=$(basename $sample ".qc.pe.R1.fq.gz");
dir3="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/PHIX_FILTERED"
bbmap.sh ref=${dir1}/Phix174.fasta \
     in=${dir2}/${base}.qc.pe.R1.fq.gz \
     in2=${dir2}/${base}.qc.pe.R2.fq.gz \
     outm=${dir3}/${base}.qc.PE.mappedtoPHIX.fq.gz \
     outu=${dir3}/${base}.qc.PE.unmapped.fq.gz \
     threads=16 pairedonly=t pigz=t printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t tossbrokenreads=t; done
echo "END TIME": '' 'date'
##

################## STEP 3 ###########
## (5.1) Error-correction with "tadpole"
## files are too large for "Bayershummer" implemented in SPADES!

### vIn Batch

cat > Run_ErrorCorrection_Tadpole.sh

#!/bin/bash
#SBATCH -c 28                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Tad1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=250G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Tadpole2_logouput.out
#SBATCH --error=Tadpole2_run_errors.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
dir1="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/PHIX_FILTERED"
dir2="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/ERROR_CORRECTED"
FILES=($dir1/*.qc.PE.unmapped.fq.gz)

# Iterate through files in batches of 3
for (( i=0; i<${#FILES[@]}; i+=3 )); do
batch=("${FILES[@]:i:3}")
for file in "${batch[@]}"; do
base=$(basename $file ".qc.PE.unmapped.fq.gz")
sbatch --cpus-per-task=2 --mem=80G --wrap="tadpole.sh \
in=${dir1}/${base}.qc.PE.unmapped.fq.gz \
out=${dir2}/${base}.qc.ec.PE.fq.gz \
threads=8 ecc=t rollback=t pincer=t tail=t prefilter=t prealloc=t mode=correct tossbrokenreads=t"
done
done

echo "END TIME": '' 'date'
#


#################### STEP 4 ##############
### (5.1) Assembly reads with SPADes # MG Mode
## SPAdes genome assembler v4.0.0
## February 09, 2025


## use high memory partition
## Modified Script with File Size-Based Memory Allocation

cat > RUN_SPADesAssembly_inbatches.sh

#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=Spd2
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p highmem                  # Partition to submit to
#SBATCH --mem=510G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SPADEs2_logouput.out
#SBATCH --error=SPADEs2_run_errors.err
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'

# Set up variables
READS_DIR="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/ERROR_CORRECTED"
ASSEMBLY_DIR="/gxfs_work/geomar/smomw647/PROJECTS/FRESHWATERBioDiv/SOUTH_AFRICAN_LAKES/ASSEMBLIES"
FILES=($READS_DIR/*.qc.ec.PE.fq.gz)

# Iterate through files in batches of 2
for (( i=0; i<${#FILES[@]}; i+=2 )); do
    batch=("${FILES[@]:i:2}")
    for file in "${batch[@]}"; do
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
        sbatch --cpus-per-task=$cpus --mem-per-cpu=$mem_per_cpu --wrap="spades.py -t $cpus -m $(( ${mem_per_cpu%G} * cpus )) -k 21,33,55,71,99,113,127 --meta --only-assembler --12 ${READS_DIR}/${base}.qc.ec.PE.fq.gz -o ${ASSEMBLY_DIR}/${base}_SPADessembly"
    done
done
# End the job
echo "END TIME": '' 'date'
#




