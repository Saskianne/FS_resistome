#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ASG_SRRDwnd
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=SRRDownload_ASG.out
#SBATCH --error=SRRDownload_ASG_run_errors_2.err
# here starts your actual program call/computation
#
cd /gxfs_work/geomar/smomw681/DATA
echo "START TIME": '' 'date'
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate FastqDump
export http_proxy=http://10.0.7.235:3128

for i in $(cat assembly_ASG_list.txt)
do
     OUTPUTDIR="/gxfs_work/geomar/smomw681/DATA/RAWDATA"
     echo "Download starts at": '' 'time' "on" 'date'
     echo working with $i
     ncbi-genome-download -A $i -p 10 -l all -o ${OUTPUTDIR}; 
     echo "Download ends at": '' 'time' "on" 'date'
done
echo "END TIME": '' 'date'
##
