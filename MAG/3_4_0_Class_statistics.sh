#!/bin/bash
#SBATCH -c 16                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExProks
#SBATCH -t 9-00:00                # Runtime in D-HH:MMs
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=DMCExctract1_ouputlog_Proks.out
#SBATCH --error=DMCExctract1_errors_Proks.err
# here starts your actual program call/computation

# Statistics of the deepmicroclass outputs

module load gcc12-env/12.3.0
module load miniconda3/24.11.1
module load gcc/12.3.0
source ~/perl5/perlbrew/etc/bashrc
perlbrew switch perl-5.38.0

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS
PROKS_CONTIG_DIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"

echo start creating a stats file for prokaryotic contigs

perl SL_Fasta_Files_stats_2024_version.pl \
${PROKS_CONTIG_DIR} > "FS_proks_Statistics.xls"

echo finished creating a stat file for prokaryotic contigs

# input 1 = input folder
# input 2 = cutoff_length (default 0)
# output _Statistics.xls file with 
## n50, total contigs counts, total length of contigs, gc count, mi/max/mean contig length





