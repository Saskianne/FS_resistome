#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=CtgRen
#SBATCH -p base                  # Partition to submit to
#SBATCH --mem=50G                 # Memory pool for all cores (see also --mem-per-cpu)
#
# here starts your actual program call/computation
#
echo "START TIME": '' 'date'
for i in /gxfs_work/geomar/smomw681/DATA/ASSEMBLIES/DONE/CONTIGs/ORIGINAL/*_SPADessembly.fna
do
     echo working with $i
     newfile="$(basename $i _SPADessembly.fna)"
     perl /gxfs_home/geomar/smomw647/ComGenomicsTools/bac-genomics-scripts/rename_fasta_id/rename_fasta_id.pl \
     -i $i \
     -p "_SPADessemblyNODE_.+$" \
     -r "_" \
     -n -a ctg > "${newfile}_SPADessembly.fasta"
done
echo "END TIME": '' 'date'