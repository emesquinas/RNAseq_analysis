#!/bin/bash
#SBATCH --job-name=mergeSTARcounts
#SBATCH --cpus-per-task=
#SBATCH --mem=M
#SBATCH --time=00:00:00
#SBATCH --output=../logs/mergeSTARcounts_%A_%a.out
#SBATCH --error=../logs/mergeSTARcounts_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=



aligned_path=$1

#it will list all the samples (directories) and skip if there are previous files (txt) generated.
mapfile -t samples < samples.txt

#create empty file
touch $aligned_path'/RawCountsSTAR_merged.txt'

for sample in "${samples[@]}"; do
	echo $sample

	#it will save the path + name of the file for each sample
	file_path=$aligned_path'/'$sample'/Counts/Raw/'$sample'_RawCountsSTAR.txt'

	#join is  the command to merge files based on a common column. 
	# -a 1 -a 2 --> is to keep all lines from both files (to avoid losing data in case that they have genes not in common)
	#-e " " --> replace missing values (if any) with a space instead of the default of 0. 
	# -o auto --> output all fields from both files 

    	join -a 1 -a 2 -e " " -o auto "$file_path" $aligned_path'/RawCountsSTAR_merged.txt' > $aligned_path'/tmp.txt'

	#replace tmp file for the final one.
	mv $aligned_path'/tmp.txt' $aligned_path'/RawCountsSTAR_merged.txt'
done
