#!/bin/bash
#SBATCH --job-name=STAR_Alignment
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/STAR_alignment_%A_%a.out
#SBATCH --error=../logs/STAR_alignment_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)
threads=$SLURM_CPUS_PER_TASK

#path where the data is
data_path=$1
#path to save the mapped files
output_path=$2
GenomeIndex=$3

output_path_sample=$output_path'/'$sample'/'
mkdir -p $output_path_sample

#load STAR into the environment
module load cesga/2020 gcc/system star/2.7.10b


echo 'Sample: ' $sample
echo "Starting the alignment..."

sample1=$data_path'/'$sample'/'$sample'_1.fq.gz'
sample2=$data_path'/'$sample'/'$sample'_2.fq.gz'


STAR \
	--runThreadN $threads \
	--genomeDir $GenomeIndex \
	--readFilesIn $sample1 $sample2 \
	--readFilesCommand zcat \
	--outFileNamePrefix $output_path_sample${sample}'_' \
	--outTmpDir $output_path_sample'temp' \
	--outReadsUnmapped Fastx \
	--outSAMtype BAM SortedByCoordinate \
	--quantMode GeneCounts

echo "FINISHED"



#NOTES
#--runThreadN: number of threads to run STAR \ #Example cores = 8 (8x2=16) 
#--genomeDir #where the genome index is stored (generated before)
#--readFilesIn $data_path''$sample'_1.fastq.gz' $data_path''$sample'_2.fastq.gz' \
#--readFilesCommand zcat \ #to uncompress .gz files
#--outTmpDir #it creates a new temporary directory to save the temp files.
#--outFileNamePrefix $output_path'mapped/'$sample'_' \ #change standard name of the output files
#--outReadsUnmapped Fastx \ #output of unmapped and partially mapped (i.e. mapped only one mate of a paired end read) reads in separate fasta/fastq file(s).
#--quantMode GeneCounts \ # get counts reads per gene. Similar to use Htseq.
#--outSAMtype BAM SortedByCoordinate: output - sorted files. 
# ++ Sorted by coordinate --> Aligned.sortedByCoord.out.bam file, similar to samtools sort command. If this option causes problems, it is recommended to reduce --outBAMsortingThreadN from the default 6 to lower values (as low as 1).

