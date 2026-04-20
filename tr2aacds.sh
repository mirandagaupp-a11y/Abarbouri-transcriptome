#!/bin/bash

#SBATCH --job-name=evigene_final
#SBATCH --account=5-39268
#SBATCH --mem=200000M
#SBATCH --cpus-per-task=30
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/tr2aacds3.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/tr2aacds3.err

spack load blast-plus
spack load cdhit
spack load exonerate


# Variables
# myspecies corresponds to the prefix in the IDs
# ncpu number of threads
# evigene is the path to the evidentialgene folder
# datad is your working directory
# the outputs will be in the okayset folder (merged assembly) and in the ncrnaset folder (non-coding RNAs)

ncpu=30
maxmem=200000  # in Megabytes
evigene=/work/projects/5-39268/mgaupp42/evigene
datad=/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final
myspecies=Abar_
trset=Abar_trinity_spades.tr
mrna=okayset/Abar_trinity_spades.okay.mrna

cd ${datad}

# this concatenates all .fasta transcriptome files into a single one
cat ../trinity_final.Trinity.fasta ../spades/hard_filtered_transcripts.fasta > ./evigene_final/trinity_spades.fasta

# this fixes issues with ID formatting so the concatenated file can run without issues
${evigene}/scripts/rnaseq/trformat.pl -pre $myspecies -out $trset -log -in ${datad}/trinity_spades.fasta

# main part of the script, transcriptome merging and then protein prediction
${evigene}/scripts/prot/tr2aacds4.pl -tidy -NCPU $ncpu -MAXMEM $maxmem -log -species=Ambystoma_barbouri -cdna $trset

# this extracts the non-coding rnas from the transcriptome, for further analyses
${evigene}/scripts/genes/tr2ncrna.pl -debug -log  -ncpu $ncpu  -mrna $mrna -trset $trset
