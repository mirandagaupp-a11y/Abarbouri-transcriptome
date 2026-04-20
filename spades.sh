#!/bin/bash

#SBATCH --job-name=spades
#SBATCH --cpus-per-task=28
#SBATCH --time=7-00:00:00
#SBATCH --partition=hugemem
#SBATCH --mem=800G
#SBATCH --account=5-39268
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/spades/spades.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/spades/spades.err

spack load spades@3.15.5
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

spades.py --rna -1 ${MY_FOLDER}/transcriptome_assembly/rcorrector/master.R1.fq.gz  \
	-2  ${MY_FOLDER}/transcriptome_assembly/rcorrector/master.R2.fq.gz \
	-o ${MY_FOLDER}/transcriptome_assembly/spades/ -t $SLURM_CPUS_PER_TASK -m $(( $SLURM_MEM_PER_NODE / 1024 ))