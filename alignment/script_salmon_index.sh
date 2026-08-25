#!/bin/bash
#SBATCH --job-name=Salmon_Index
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/SALMON_index_%A.out
#SBATCH --error=../logs/SALMON_index_%A.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


Transcriptome=$1
OutputPath=$2
Decoys_file=$3

#load Salmon
module load cesga/2020 gcccore/system salmon/1.5.2

salmon index \
	-t $Transcriptome \
	-i $OutputPath \
	--decoys $Decoys_file \
	-k 31 \
 

echo "Done, index can be found in: " $OutputPath
