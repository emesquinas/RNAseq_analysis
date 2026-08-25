#!/bin/bash
#SBATCH --job-name=STAR_Index
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/STAR_index_%A_%a.out
#SBATCH --error=../logs/STAR_index_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


Genome=$1
GTF=$2
output_path=$3
readLength=$4
threads=$SLURM_CPUS_PER_TASK

echo "STAR index using: " $Genome "and " $GTF
echo "Read Length: " $readLength 

#load STAR 
module load cesga/2020 gcc/system star/2.7.10b

STAR \
	--runThreadN $threads \
	--runMode genomeGenerate \
	--genomeDir $output_path \
	--genomeFastaFiles $Genome \
	--sjdbGTFfile $GTF \
	--sjdbOverhang $readLength \

echo "Done, index can be found in: " $output_path
