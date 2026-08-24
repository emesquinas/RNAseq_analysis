#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --cpus-per-task=
#SBATCH --mem=G
#SBATCH --time=00:00:00
#SBATCH --output=../logs/multiqc_%A.out
#SBATCH --error=../logs/multiqc_%A.err
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=



output_path=$1
results_path=$2

module load multiqc

multiqc -o $output_path $results_path


