#!/bin/bash

#SBATCH --job-name=longorfs
#SBATCH --mem=200G
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/transdecoder/post_final_ncbi_filtering/transdecoder1.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/transdecoderpost_final_ncbi_filtering/transdecoder1.err

spack load singularityce@3.11.3
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

singularity run --bind /work:/work ${MY_FOLDER}/transdecoder.v5.7.1.simg TransDecoder.LongOrfs \
	-t ${MY_FOLDER}/transcriptome_assembly/evigene_final/ncbi_filtering/Abarbouri_transcriptome_ncbi_filtered.fsa --output_dir ${MY_FOLDER}/transcriptome_assembly/transdecoder/post_final_ncbi_filtering/