#!/bin/bash

#SBATCH --job-name=trinotate_post_ncbi
#SBATCH --account=5-39268
#SBATCH --mem=200G
#SBATCH --cpus-per-task=20
#SBATCH --time=5-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/trinotate_post_ncbi/trinotate_post_ncbi2.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/trinotate_post_ncbi/trinotate_post_ncbi2.err

spack load singularityce@3.11.3
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
export TRINOTATE_HOME=/usr/local/src/Trinotate
cd ${MY_FOLDER}

#singularity run --bind /work:/work/ trinotate.v4.0.1.simg ${TRINOTATE_HOME}/Trinotate --db ${MY_FOLDER}TRINOTATE_DATA_DIR/myTrinotate.sqlite --init \
#	--gene_trans_map ${MY_FOLDER}transcriptome_assembly/evigene_final/ncbi_filtering/Abarbouri_gene_trans_map.txt \
#	--transcript_fasta ${MY_FOLDER}transcriptome_assembly/evigene_final/ncbi_filtering/Abarbouri_transcriptome_final.fsa \
#	--transdecoder_pep ${MY_FOLDER}transcriptome_assembly/transdecoder/post_final_ncbi_filtering/Abarbouri_transcriptome_ncbi_filtered.fsa.transdecoder.pep

singularity run --bind /work:/work/ trinotate.v4.0.1.simg ${TRINOTATE_HOME}/Trinotate --db ${MY_FOLDER}TRINOTATE_DATA_DIR/myTrinotate.sqlite --CPU 20 \
	--transcript_fasta ${MY_FOLDER}transcriptome_assembly/evigene_final/ncbi_filtering/Abarbouri_transcriptome_final.fsa \
	--transdecoder_pep ${MY_FOLDER}transcriptome_assembly/transdecoder/post_final_ncbi_filtering/Abarbouri_transcriptome_ncbi_filtered.fsa.transdecoder.pep \
	--trinotate_data_dir ${MY_FOLDER}/TRINOTATE_DATA_DIR \
	--run "swissprot_blastp swissprot_blastx pfam infernal EggnogMapper"

#singularity run --bind /work:/work/ trinotate.v4.0.1.simg ${TRINOTATE_HOME}/Trinotate --db ${MY_FOLDER}TRINOTATE_DATA_DIR/myTrinotate.sqlite
#	--LOAD_swissprot_blastp ${MY_FOLDER}uniprot_sprot.ncbi.blastp.outfmt6
#	--LOAD_pfam ${MY_FOLDER}TrinotatePFAM.out
#	--LOAD_signalp6 ${MY_FOLDER}prediction_results.txt
#	--LOAD_EggnogMapper ${MY_FOLDER}eggnog_mapper.emapper.annotations
#	--LOAD_swissprot_blastx ${MY_FOLDER}uniprot_sprot.ncbi.blastx.outfmt6
#	--LOAD_infernal ${MY_FOLDER}infernal.out


#singularity run --bind /work:/work/ trinotate.v4.0.1.simg ${TRINOTATE_HOME}/Trinotate --db ${MY_FOLDER}TRINOTATE_DATA_DIR/myTrinotate.sqlite \
#	--report --incl_pep --incl_trans