#!/bin/bash
#SBATCH --job-name=strandedness
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/strandedness_%A_%a.out
#SBATCH --error=../logs/strandedness_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)
data_path=$1
output_path=$2
GTF_file=$3
cDNA_file=$4

cd $output_path # move the output folder (cause it will create a results folder there)

#load the tool
module load cesga/2020 gcccore/system kallisto/0.46.1

check_strandedness --gtf $GTF_file --transcripts $cDNA_file --reads_1 $data_path'/'$sample'/'$sample'_1.fq.gz' --reads_2 $data_path'/'$sample'/'$sample'_2.fq.gz'
