#!/bin/bash
#SBATCH -c 4                      # 1 core per job (i.e., if you need 8 cores, you would have to use "-c 8")
#SBATCH --job-name=MetaBat2
#SBATCH -t 9-00:00                # Runtime in D-HH:MM
#SBATCH --qos=long                  # quality of service parameters
#SBATCH -p base                  # Partition to submit to                  # Partition to submit to
#SBATCH --mem=150G                 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --output=PacBio_metaBAT2_MAGs.out
#SBATCH --error=PacBio_metaBAT2_MAGs.err
#SBATCH --mail-type=END           # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=dngugi@geomar.de  # Email to which notifications will be sent
# here starts your actual program call/computation
#
module load gcc12-env/12.3.0
module load miniconda3/24.11.1

PacBio_Assembly="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly"
MAG_PacBio="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio"
wtdbg_noEC_CONTIG_FILEs="/gxfs_work/geomar/smomw681/DATA/MAG_PacBio/CONTIGs_wtdbg2_raw"
PacBio_RAW="/gxfs_work/geomar/smomw681/DATA/RAWDATA/PacBio_runs"

BAM_FILEs="${MAG_PacBio}/BAMFILEs_PacBio"
COV_FILEs="${MAG_PacBio}/COVERAGE_PacBio"
METABAT2_FILEs="${MAG_PacBio}/METABAT2_PacBio"
EC_READs="/gxfs_work/geomar/smomw681/DATA/PacBio_Assembly/Canu/SRR*"

echo "START TIME": '' $(date)

# conda activate Assembly
# cd /gxfs_work/geomar/smomw681/DATA/MAG_PacBio/BAMFILEs_PacBio

# echo starting bbmap at $(date)
# for dir in ${EC_READs[@]};
# do
#     base=$(basename $dir "_1.fastq.gz");
#     if [ ! -f ${BAM_FILEs}/${base}.out.bam ]; then
#         echo working on $base 
#         bbmap.sh \
#             ref=${wtdbg_noEC_CONTIG_FILEs}/${base}.ctg.fastq \
#             in=${dir}/${base}.correctedReads.fasta.gz \
#             out=${BAM_FILEs}/${base}.out.bam \
#             threads=8 pairedonly=t pigz=t \
#             printunmappedcount=t timetag=t unpigz=t rebuild=f overwrite=f ordered=t bamscript=bs.sh; \
#             sh bs.sh; 
#         echo .bam file for $base is now has been created
#     else
#         echo "BAM file for $dir already exist"
#     fi
# done

# echo starting with samtools sort at $(date)
# for sample in ${BAM_FILEs}/*.out.bam;
# do
# base=$(basename $sample ".out.bam")
# if [ ! -f ${BAM_FILEs}/${base}.out.sorted.bam ]; then
#     echo working on $base
#     samtools sort \
#         -o ${BAM_FILEs}/${base}.out.sorted.bam \
#         --output-fmt BAM \
#         --threads 16 \
#         --reference ${wtdbg_noEC_CONTIG_FILEs}/${base}.ctg.fastq \
#         $sample; 
#     echo .sorted.bam file for $base is now has been created
# else
#     echo "BAM file $sample already exist"
# fi
# done
# echo samtools sort completed at $(date)

echo start extracting coverage information using jgi_summarize_bam_contig_depths at $(date)
conda activate METABAT2
for sample in ${BAM_FILEs}/*.out.sorted.bam;
do
base=$(basename $sample ".out.sorted.bam")
if [ ! -f ${COV_FILEs}/${base}.depth.txt ]; then
    jgi_summarize_bam_contig_depths \
        --outputDepth ${COV_FILEs}/${base}.depth.txt \
        --pairedContigs ${COV_FILEs}/${base}.paired.txt \
        --referenceFasta ${wtdbg_noEC_CONTIG_FILEs}/${base}.ctg.fastq \
        ${BAM_FILEs}/${base}.out.sorted.bam; 
    echo .depth.txt file for $base is now has been created
elif [ -f ${COV_Files}/${base}.depth.txt ]; then
    echo "depth.txt file for $sample already exist"
else
    echo something is wrong here
fi
done
echo  "Usually, paired.txt files are not generated, so don't worry about that"
echo Done with generation of coverage files at $(date)

echo start binning with METBAT2 at $(date)
cd /gxfs_work/geomar/smomw681/DATA/MAG_Illumina/METABAT2
for sample in ${wtdbg_noEC_CONTIG_FILEs}/*.ctg.fastq;
do
base=$(basename $sample ".ctg.fastq");
if [ ! -f ${METABAT2_FILEs}/${base}.metabat2.pbbin.* ]; then
metabat2 -t 6 -m 1500 \
    -o ${METABAT2_FILEs}/${base}.metabat2.pbbin.fasta \
    -d -v -i $sample ; # -a ${COV_FILEs}/${base}.depth.txt: coverage information left out due to low coverage of PacBio Seq
elif [ -f ${METABAT2_FILEs}/${base}.metabat2.pbbin.* ]; then 
     echo "File exists: ${base}.metabat2.pbbin";
else
     echo Something went wrong. 
fi     
done
echo "METABAT2 binning completed at $(date)"

echo "END TIME": '' $(date)
##
