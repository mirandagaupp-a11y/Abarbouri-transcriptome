#!/bin/bash

#SBATCH --job-name=trinity_final
#SBATCH --mem=300G
#SBATCH --cpus-per-task=30
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/trinity_final.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/trinity_final.err

spack load singularityce@3.11.3
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

singularity run --bind /work:/work ${MY_FOLDER}/trinityrnaseq.v2.15.1.simg Trinity \
	--seqType fq \
	--left ${MY_FOLDER}/transcriptome_assembly/rcorrector/master_filtered_master.R1.fq.gz \
	--right ${MY_FOLDER}/transcriptome_assembly/rcorrector/master_filtered_master.R2.fq.gz \
	--max_memory 300G --CPU 30 \
	--output ${MY_FOLDER}/transcriptome_assembly/trinity_final
