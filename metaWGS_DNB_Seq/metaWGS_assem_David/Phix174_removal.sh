#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=PhIX1
#SBATCH -t 10-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PHIX1_FILTERED_ouputlog.out
#SBATCH --error=PHIX1_FILTERED_errors.err
#
echo "START TIME: $(date)"

# Load modules or resources
#module load gcc12-env/12.3.0
#module load miniconda3/24.11.1
#module load miniconda3/23.5.2
#conda activate AVIARY

# Set proxy if needed
export http_proxy=http://10.0.7.235:3128
export https_proxy=http://10.0.7.235:3128

## Execute
for sample in `ls /gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/QCed_DATA/*.qc.pe.R1.fq.gz`;
do
dir1="/gxfs_work/geomar/smomw647/DATABASES/CONTAMINANTs"
dir2="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/QCed_DATA"; base=$(basename $sample ".qc.pe.R1.fq.gz");
dir3="/gxfs_work/geomar/smomw647/PROJECTS/SPONGEMicrobiome/COLLABORATIONs/SUNWOO/PROJECT_SCHWENTINE/BGI_METAGENOMES_OCT212025/PHIX_FILTERED"
bbmap.sh ref=${dir1}/Phix174.fasta \
     in=${dir2}/${base}.qc.pe.R1.fq.gz \
     in2=${dir2}/${base}.qc.pe.R2.fq.gz \
     outm=${dir3}/${base}.qc.PE.mappedtoPHIX.fq.gz \
     outu=${dir3}/${base}.qc.PE.unmapped.fq.gz \
     threads=16 pairedonly=t pigz=t printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t tossbrokenreads=t; done

echo "END TIME: $(date)"
##
