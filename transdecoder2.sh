#!/bin/bash

#SBATCH --job-name=predict
#SBATCH --mem=200000M
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/transdecoder/post_final_ncbi_filtering/transdecoder2.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/transdecoder/post_final_ncbi_filtering/transdecoder2.err

spack load singularityce@3.11.3
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

singularity run --bind /work:/work ${MY_FOLDER}/transdecoder.v5.7.1.simg TransDecoder.Predict \
	-t ${MY_FOLDER}/transcriptome_assembly/evigene_final/ncbi_filtering/Abarbouri_transcriptome_ncbi_filtered.fsa --output_dir ${MY_FOLDER}/transcriptome_assembly/transdecoder/post_final_ncbi_filtering/