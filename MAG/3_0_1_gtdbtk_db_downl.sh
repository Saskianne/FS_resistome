#!/bin/bash
#SBATCH -c 10                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=SRRDwnd2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=10G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=gtdbtk_db_download.out
#SBATCH --error=gtdbtk_db_download.err
# here starts your actual program call/computation
#
echo "START TIME": '' $(date)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
export http_proxy=http://10.0.7.235:3128

download-db.sh 

echo "END TIME": '' $(date)

##