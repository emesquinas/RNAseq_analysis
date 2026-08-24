#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/fastqc_%A_%a.out
#SBATCH --error=../logs/fastqc_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)
threads=$SLURM_CPUS_PER_TASK

data_path=$1
output_path=$2

#load tool
module load fastqc/0.12.1

sample1=$data_path''$sample'/'$sample'_1.fq.gz'
sample2=$data_path''$sample'/'$sample'_2.fq.gz'


echo "FastQC on: " $sample

fastqc \
	-o $output_path \
	-t $threads \
	$sample1 $sample2 \
