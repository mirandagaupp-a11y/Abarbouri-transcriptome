#!/bin/bash

#SBATCH --job-name=filtering
#SBATCH --account=5-39268
#SBATCH --mem=200G
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/gx_clean.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/gx_clean.err

spack load singularityce@3.11.3

#This was run in a step wise fashion# 

cd /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering

#./run_fcsadaptor.sh --fasta-input /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/cdhit/Abar_trinity_spades.95.unitigs.fasta --output-dir ./outputdir --euk --container-engine singularity --image ./fcs-adaptor.sif

#cat /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/cdhit/Abar_trinity_spades.95.unitigs.fasta | python3 ./fcs.py clean genome --action-report ./outputdir/fcs_adaptor_report.txt --output clean.fasta --contam-fasta-out contam.fasta

#LOCAL_DB="/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/"
#./s5cmd  --no-sign-request cp  --part-size 50  --concurrency 50 s3://ncbi-fcs-gx/gxdb/latest/all.* $LOCAL_DB

#export FCS_DEFAULT_IMAGE=/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/fcs-gx.sif
#SOURCE_DB_MANIFEST="https://ncbi-fcs-gx.s3.amazonaws.com/gxdb/latest/all.manifest"
#LOCAL_DB="/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/"
#python3 fcs.py db get --mft "$SOURCE_DB_MANIFEST" --dir "$LOCAL_DB/gxdb"

#export FCS_DEFAULT_IMAGE=/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/fcs-gx.sif

#python3 ./fcs.py screen genome \
#  --fasta clean1.fasta \
#  --out-dir ./gx_out \
#  --gx-db /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering \
#  --tax-id 238860

export FCS_DEFAULT_IMAGE=/work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/ncbi_filtering/fcs-gx.sif

cat clean1.fasta | python3 ./fcs.py clean genome --action-report ./gx_out/clean1.238860.fcs_gx_report.txt --output gx_clean.fasta --contam-fasta-out gx_contam.fasta