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
echo "START TIME": '' $(date -u)
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate FastqDump
export https_proxy=http://10.0.7.235:3128

OUTPUTDIR="/gxfs_work/geomar/smomw681/DATA/ASG_MAG"

echo "Download starts at: $(date -u)"

echo working with ERZ21784910
wget -nc -P ${OUTPUTDIR} ftp://ftp.sra.ebi.ac.uk/vol1/analysis/ERZ217/ERZ21784910/odEunFrag1.metagenome.1.primary.fa.gz

echo working with ERZ18440741
wget -nc -P ${OUTPUTDIR} ftp://ftp.sra.ebi.ac.uk/vol1/analysis/ERZ184/ERZ18440741/odSpoLacu1.metagenome.1.primary.fa.gz


echo "Download ends at:'' $(date -u)"


##