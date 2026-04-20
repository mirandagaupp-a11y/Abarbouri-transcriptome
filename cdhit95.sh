#!/bin/bash

#SBATCH --job-name=cd_hit_95
#SBATCH --mem=200G
#SBATCH --cpus-per-task=30
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/cdhit/cd_hit95.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/cdhit/cd_hit95.err

spack load cdhit@4.8.1
cd /work/projects/5-39268/mgaupp42/

cd-hit-est -i ./transcriptome_assembly/evigene_final/kraken/Abar_trinity_spades.unclassified.fa -o ./transcriptome_assembly/evigene_final/cdhit/Abar_trinity_spades.95.unitigs.fasta -c 0.95 -M 6000