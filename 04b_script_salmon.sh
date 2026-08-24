#!/bin/bash
#SBATCH --job-name=Salmon_Alignment
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/Salmon_alignment_%A_%a.out
#SBATCH --error=../logs/Salmon_alignment_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)
threads=$SLURM_CPUS_PER_TASK

#path where the data is
data_path=$1
#path to save the mapped files
OutputPath=$2
SalmonIndex=$3

output_path_sample=$OutputPath'/'$sample'/'
mkdir -p $output_path_sample

#load salmon into the environment
module load cesga/2020 gcccore/system salmon/1.5.2


echo 'Sample: ' $sample
echo "Starting the alignment..."

sample1=$data_path'/'$sample'/'$sample'_1.fq.gz'
sample2=$data_path'/'$sample'/'$sample'_2.fq.gz'


salmon quant \
	-i $SalmonIndex \
	-l A \
	-1 $sample1 -2 $sample2 \
	--validateMappings \
	--gcBias \
	--numBootstraps 30 \
	-p $threads \
	-o $output_path_sample

echo "FINISHED"

