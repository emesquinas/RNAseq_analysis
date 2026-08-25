#!/bin/bash
#SBATCH --job-name=fastq_screen
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/fastq_screen_%A_%a.out
#SBATCH --error=../logs/fastq_screen_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)

data_path=$1
output_path=$2
path_fastq_screen='Tools/FastQ_Screen/fastq_screen_v0.14.0/'
threads=$SLURM_CPUS_PER_TASK

echo "FastQ Screen on: " $sample


fastq_screen \
	--conf $path_fastq_screen'fastq_screen.conf' \
	--outdir $output_path \
	--threads $threads \
	$data_path'/'$sample'/'$sample'_1.fq.gz' $data_path'/'$sample'/'$sample'_2.fq.gz'
