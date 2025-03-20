#!/bin/bash
#SBATCH -c 2                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=ExProks
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=100G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=Assem_all_3.out
#SBATCH --error=Assem_all_3.err
# here starts your actual program call/computation

## STEP 6
### EXTRACT CONTIGs FOR THE DIFFERENT CLASSES#
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1
conda activate MAG
source $HOME/my_python_env/my_env/bin/activate
module load python/3.11.5

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass
CONTIG_Dir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CONTIGs_renamed"
OUTPUTDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
TSVDir="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/DEEPMicroClass"

echo "START TIME": '' $(date)

echo start to extract Prokaryote contigs
for i in ${CONTIG_Dir}/*_contigs_min500_renamed.fasta;
do
file=$(basename $i "_renamed.fasta");
if [ ! -f ${OUTPUTDir}/${file}_Proks.fna ]; then
    echo working with $i
    base=$(basename $i "_contigs_min500_renamed.fasta");
    DeepMicroClass extract \
        --fasta $i \
        --class Prokaryote \
        --output ${OUTPUTDir}/${base}_contigs_min500_Proks.fna \
        --tsv ${TSVDir}/${base}_contigs_min500_renamed.fasta_pred_onehot_hybrid.tsv; 
    echo done with $i
else
    echo "File already exists"
fi            
done

echo finished extracting Prokaryote contigs
echo start with prodigal 

cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL
ProdDIR="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PRODIGAL"

for i in /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS/*_contigs_min500_Proks.fna;
do
newfile="$(basename $i _contigs_min500_Proks.fna)"
if [ ! -f ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna ]; then
    echo working with $i
    pprodigal --tasks 4 --chunksize 20000 -p meta -m \
        -i $i \
        -o ${ProdDIR}/GBB_Temp.gbk \
        -d ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna \
        -a ${ProdDIR}/ORFs_ORIGINAL/${newfile}.PROKS.ORFs.faa
    echo done with $i
else 
    echo "File ${ProdDIR}/CDS_ORIGINAL/${newfile}.PROKS.CDS.fna already exists"
fi
done

echo finished prodigal

conda activate Assembly
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs

PROK_CONTIGs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/CLASS_CONTIGs/PROKS"
EC_READs="/gxfs_work/geomar/smomw681/DATA/ERROR_CORRECTED"
BAM_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2/BAMFILEs"

echo starting bbmap at $(date)
for sample in ${EC_READs}/*.qc.ec.PE.fq.gz;
do
    base=$(basename $sample ".qc.ec.PE.fq.gz")
    if [ ! -f ${BAM_FILEs}/${base}.out.bam ]; then
        echo working on $sample 
        bbmap.sh \
            ref=${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
            in=${EC_READs}/${base}.qc.ec.PE.fq.gz \
            out=${BAM_FILEs}/${base}.out.bam \
            threads=16 pairedonly=t pigz=t \
            printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t bamscript=bs.sh; sh bs.sh; 
        echo .bam file for $base is now has been created
    else
        echo "BAM file $sample already exist"
    fi
done

echo bbmap completed at $(date)
echo starting with samtools sort at $(date)

for sample in ${BAM_FILEs}/*.out.bam;
do
base=$(basename $sample ".out.bam")
if [ ! -f ${BAM_FILEs}/${base}.out.sorted.bam ]; then
    echo working on $base
    samtools sort \
        -o ${BAM_FILEs}/${base}.out.sorted.bam \
        --output-fmt BAM \
        --threads 16 \
        --reference ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna \
        $sample; 
    echo .sorted.bam file for $base is now has been created
else
    echo "BAM file $sample already exist"
fi
done

echo samtools sort completed at $(date)

echo start extracting coverage information using jgi_summarize_bam_contig_depths at $(date)
conda activate METABAT2
for sample in ${BAM_FILEs}/*.out.sorted.bam;
do
base=$(basename $sample ".out.sorted.bam")
if [ ! -f ${COV_Files}/${base}.depth.txt ]; then
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_Files}/${base}.depth.txt \
        --pairedContigs ${COV_Files}/${base}.paired.txt \
        ${BAM_FILEs}/${base}.out.sorted.bam \
        --referenceFasta ${PROK_CONTIGs}/${base}_contigs_min500_Proks.fna; 
    echo .depth.txt file for $base is now has been created
elif [ -f ${COV_Files}/${base}.depth.txt ]; then
    echo "depth.txt file for $sample already exist"
else
    echo something is wrong here
fi
done
echo  "Usually, paired.txt files are not generated, so don't worry about that"
echo Done with generation of coverage files at $(date)


echo starting QC for mapping file for Proks_contigs at $(date)

conda activate PacBio_Assembly
cd cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/
QC_RESULTS="/gxfs_work/geomar/smomw681/DATA/QC_RESULTS" # dir for all QC results
Proks_mapped="/gxfs_work/geomar/smomw681/DATA/MAG_Illumina/PROKS_mapped"
MAPPED_fastqc="${QC_RESULTS}/MAPPED_fastqc" # dir for QC result for mapped fastq files

for sample in ${Proks_mapped}/*.fq.gz;
do
    base=$(basename $sample ".EC_Proks_mapped.fq.gz")
    if [ ! -f ${MAPPED_fastqc}/${base}_fastqc.zip ]; then
        echo working on $sample 
        fastqc --memory 10GB -f fastq -t 4 -noextract -o $MAPPED_fastqc $sample  
        echo fastqc file for $base is now has been created
    elif [ -f ${MAPPED_fastqc}/${base}_fastqc.zip ]; then
        echo "fastqc file $sample already exist"
    else
        echo "fastqc for $sample: something went wrong"
    fi
done
multiqc --force -o $MAPPED_fastqc -n MAPPED_fastqc_summary -i MAPPED_fastqc_summary -p ${MAPPED_fastqc}   

echo Done with QC for mapping file for Proks_contigs at $(date)

echo "END TIME": '' $(date)
##
