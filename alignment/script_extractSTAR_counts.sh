#!/bin/bash
#SBATCH --job-name=ExtractSTARcounts
#SBATCH --array=1-6
#SBATCH --cpus-per-task=
#SBATCH --mem=M
#SBATCH --time=00:00:00
#SBATCH --output=../logs/ExtractCountsSTAR_%A_%a.out
#SBATCH --error=../logs/ExtractCountsSTAR_%A_%a.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=


#save the name of the sample (taken from samples.txt) for each job launched in the array
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)

aligned_path=$1
output_path=$aligned_path'/'$sample'/Counts/Raw/'
mkdir -p $output_path

#remove the first 5 files of the file $sample_ReadsPerGene.out.tab (tail -n +5) and keep the first and fourth column of the same file.

#Note about the "ReadsPerGene.out.tab" file
#column 1: gene ID
#column 2: counts for unstranded RNA-seq
#column 3: counts for the 1st read strand aligned with RNA (htseq-count option -s yes
#column 4: counts for the 2nd read strand aligned with RNA (htseq-count option -s reverse)
#Select the output according to the strandedness of your data. 

#Take the reverse column
tail -n +5 $aligned_path'/'$sample'/'$sample'_ReadsPerGene.out.tab' | cut -f 1,4 > $output_path'tmp.txt'

# add a header: GeneID and $sample
#BEGIN {print "GeneID ${sample}"}: This is a special block that is executed once, before any lines from the input file are processed. In this block, the print statement prints the string "GeneID" followed by the value of the sample variable ($sample).
#Note that we need to use double quotes to allow variable expansion in the print statement, and we need to escape the double quotes around the string with backslashes
#{print}: This block is executed for each line of the input file. In this block, the print statement simply prints the entire line (i.e., the contents of each line of "tmp.txt"). Without this command, we only keep the header and the rest of the file is lost.

awk "BEGIN {print \"GeneID ${sample}\"} {print}" $output_path'tmp.txt' > $output_path''$sample'_RawCountsSTAR.txt'


#remove temporary file.
rm $output_path'tmp.txt'

