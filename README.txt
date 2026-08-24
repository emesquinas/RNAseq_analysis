Scripts to launch a RNA-seq analysis:
- QC: FastQC, FastQ-Screen, Strandedness (with Kallisto), MultiQC
- Alignment: STAR / Salmon

Disclaimer: this scripts are prepared assuming that the work environment will be the HPC CESGA (Galician Supercomputing Center) due the tools are loaded as modules installed in the cluster. 
Version of the tools:
- FastQC: 0.12.1
- FastQ Screen: 0.14.0 (installed in the cluster, not module)
- Kallisto: 0.46.1
- STAR: 2.7.10b
- Salmon: 1.5.2
- MultiQC: 1.24.1-python-3.9.9

Files/Scripts to be modified:
- launcher.sh --> paths, folder names or steps (e.g. if the transcriptome alignment does not want to be done)
- samples.txt --> file with the sample names

