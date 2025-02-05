#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SRRDwnd2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SRRDownload_output_2.out
#SBATCH --error=SRRDownload_run_errors_2.err
# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA/RAWDATA
echo "START TIME": '' 'date'
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate FastqDump
export http_proxy=http://10.0.7.235:3128

for i in $(cat srr_ncbi_list.txt)
do
OUTPUTDIR="/gxfs_work/geomar/smomw681/DATA/RAWDATA"
     if [ -f $i_1.fastq.gz ] && [ -f $i_2.fastq.gz ]; then
          echo "fastq files of {$i} exist"
     else
          echo "fastq files of {$i} do not exist"
          echo working with $i
          parallel -j 10 fastq-dump --outdir ${OUTPUTDIR}/ --gzip --split-files {} ::: $i; 
     fi
done
echo "END TIME": '' 'date'
##
