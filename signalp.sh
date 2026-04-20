#!/bin/bash
#SBATCH --job-name=signalp
#SBATCH --mem=300G
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/signal/signalp.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/signal/signalp.err

#spack load python@3.11.6
spack load py-numpy@1.26.1
#spack load py-matplotlib@3.8.1
#spack load /7ci3wlj


source /work/projects/5-39268/mgaupp42/signalp/bin/activate

cd /work/projects/5-39268/mgaupp42/
 
# Run SignalP
signalp6 --fastafile /work/projects/5-39268/mgaupp42/transcriptome_assembly/transdecoder/Abar_trinity_spades.95.unitigs.fasta.transdecoder.pep \
	--output /work/projects/5-39268/mgaupp42/transcriptome_assembly/signal/ \
	--organism eukarya -md /work/projects/5-39268/mgaupp42/signalp6_fast/signalp-6-package/models/