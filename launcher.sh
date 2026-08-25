#!/bin/bash


root_path=''
data_path=$root_path'Data/' #where your fastq files are
results_path=$root_path'Results/' #main folder where you want to save the results from each step

N=$(wc -l < samples.txt)

###################
#  1. FastQC      
###################

output_path_fastqc=$results_path'/QC/FastQC/'
mkdir -p $output_path_fastqc

JOB1=$(sbatch --parsable --array=1-${N} 01_script_fastqc.sh $data_path $output_path_fastqc)
echo "FastQC launched: $JOB1"

########################
#  2. FASTQ Screen      
########################

output_path_fastqscreen=$results_path'/QC/FastQScreen/'
mkdir -p $output_path_fastqscreen

JOB2=$(sbatch --parsable --array=1-${N} 02_script_fastq_screen.sh $data_path $output_path_fastqscreen)
echo "FastQ Screen launched: $JOB2"


########################
#  3. STAR (Alignment)
########################

Genome=$root_path'Data/.fa'
GTF=$root_path'Data/.gtf'

GenomeIndex_path=$results_path'/Alignment/STAR/STAR_Index/'
output_path_STAR=$results_path'/Alignment/STAR/'
readLength= #Number --> read length (e.g. 100) - 1 = 99
mkdir -p $output_path_STAR
mkdir -p $GenomeIndex_path

#STAR Index
JOB3=$(sbatch --parsable 03_script_STAR_index.sh $Genome $GTF $GenomeIndex_path $readLength)

#Alignment 
JOB4=$(sbatch --parsable --array=1-${N} --dependency=afterok:$JOB3 03_script_STAR.sh $data_path $output_path_STAR $GenomeIndex_path) #dependency on job3

echo "STAR Index launched: $JOB3"
echo "STAR alignment launched: $JOB4 (waiting for $JOB3 - STAR index)"


########################
#  3.a. STRANDEDNESS
########################

output_path_strandedness=$results_path'/QC/Strandedness/'
GTF=$root_path'.gtf'
cDNA_file=$root_path'.cdna.all.fa'

mkdir -p $output_path_strandedness
JOB5=$(sbatch --parsable 03a_script_strandedness.sh $data_path $output_path_strandedness $GTF $cDNA_file)


##########################################
#  3.b + 3.c EXTRACT + MERGE STAR COUNTS
##########################################

aligned_path=$results_path'Alignment/STAR/'

#JOB6=$(sbatch --parsable --array=1-${N} --dependency=afterok:$JOB4 03b_script_extractSTAR_counts.sh $aligned_path)
JOB6=$(sbatch --parsable --array=1-${N} 03b_script_extractSTAR_counts.sh $aligned_path)

echo "Extract counts from the alignment done by STAR: $JOB6. Waiting for the alignment ($JOB4) to be finished"

JOB7=$(sbatch --dependency=afterok:$JOB6 03c_script_mergeSTAR_counts.sh $aligned_path)
echo "Merge counts from the alignment done by STAR: $JOB7 - waiting $JOB6"


####################
#  MULTIQC
####################

output_path_multiqc=$results_path'QC/MultiQC/'
sbatch --dependency=afterok:$JOB7 script_multiqc.sh $output_path_multiqc $results_path
echo "MultiQC. Waiting for all the previous jobs to be finished"

############################
#  TRANSCRIPTOME - SALMON
############################

Transcriptome=$root_path'Data/gentrome.fa.gz'
Decoys_file=$root_path'Data/NCBI/decoys.txt'
OutputPath=$results_path'/Alignment/Salmon/'
Salmon_index=$OutputPath'SalmonIndex/'

mkdir -p $OutputPath_index

JOB8=$(sbatch --parsable 04a_script_salmon_index.sh $Transcriptome $Salmon_index $Decoys_file)
JOB9=$(sbatch --parsable --array=1-${N} --dependency=afterok:$JOB8 04b_script_salmon.sh $data_path $OutputPath $Salmon_index) #dependency on job8
