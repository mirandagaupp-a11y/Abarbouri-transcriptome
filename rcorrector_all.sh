#!/bin/bash

#SBATCH --job-name=rcorrector
#SBATCH --mem=200000M
#SBATCH --cpus-per-task=30
#SBATCH --account=5-39268
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/out/rcorrector_%a.out
#SBATCH -e /work/projects/5-39268/mgaupp42/error/rcorrector_%a.err
#SBATCH --array=0-94

#spack load /im5hi7n
spack load perl@5.38.0
perl /work/projects/5-39268/mgaupp42/rcorrector/run_rcorrector.pl

export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

file_array=(WILS_FG_1_3 WILS_FG_1_8 WILS_FG_1_9 WILS_FG_2_9 WILS_FG_2_10 WILS_FG_2_15 WILS_FG_3_10 WILS_FG_3_11 WILS_FG_3_14 \
  WILS_RW_1_3 WILS_RW_1_4 WILS_RW_1_6 WILS_RW_2_3 WILS_RW_2_4 WILS_RW_2_5 WILS_FG_1_13 WILS_FG_1_15 WILS_FG_1_17 WILS_FG_2_1 \
  WILS_FG_2_2 WILS_FG_2_3 WILS_FG_3_2 WILS_FG_3_3 WILS_FG_3_4 WILS_RW_1_7 WILS_RW_1_8 WILS_RW_1_9 WILS_RW_2_12 WILS_RW_2_13 \
  WILS_RW_2_14 RUTH_LCC_2_2 RUTH_LCC_2_3 RUTH_LCC_2_4 RUTH_LCC_2_8 RUTH_LCC_1_3 RUTH_LCC_1_5 RUTH_LCC_1_8 RUTH_LCC_1_10 \
  RUTH_LCC_1_12 RUTH_LCC_1_14 RUTH_LCC_2_10 RUTH_LCC_2_11 RUTH_LCC_2_12 RUTH_LCC_2_13 BOON_WALT_2_2 BOON_WALT_2_4 \
  BOON_WALT_2_5 BOON_WALT_2_8 BOON_WALT_2_10 BOON_WALT_2_11 BOON_WALT_3_3 BOON_WALT_3_5 BOON_WALT_3_6 \
  BOON_WALT_3_7 BOON_WALT_3_8 BOON_WALT_3_10 SCOT_JAM_1_1 SCOT_JAM_1_2 SCOT_JAM_1_5 SCOT_JAM_1_7 SCOT_JAM_1_8 \
  SCOT_JAM_1_11 SCOT_JAM_2_2 SCOT_JAM_2_5 SCOT_JAM_2_6 SCOT_JAM_2_8 SCOT_JAM_2_10 SCOT_JAM_2_11 \
  PREB_HW_1_3 PREB_HW_1_5 PREB_HW_1_7 PREB_HW_1_8 PREB_HW_1_9 PREB_HW_2_3 PREB_HW_2_5 PREB_HW_2_2 \
  PREB_HW_2_8 PREB_HW_2_9 PREB_HW_2_10 Infected_Heart1 Infected_Heart2 Infected_Liver1 \
    Infected_Liver2 Infected_Spleen1 Infected_Spleen2 Infected_Tail1 \
    Infected_Tail2 WT_Heart1 WT_Heart2 WT_Liver1 WT_Liver2 WT_Spleen1 \
    WT_Spleen2 WT_Tail1 WT_Tail2)

export sample=${file_array[${SLURM_ARRAY_TASK_ID}]}

export TDIR=$(mktemp -d)
cp ${MY_FOLDER}/transcriptome_assembly/fastp/5_filter_qual_adapt_correct/${sample}.* \
	${TDIR}
pushd ${TDIR}

perl /work/projects/5-39268/mgaupp42/rcorrector/run_rcorrector.pl -1 ${TDIR}/${sample}.R1.fq.gz -2 ${TDIR}/${sample}.R2.fq.gz -od ${MY_FOLDER}/transcriptome_assembly/rcorrector/ -t 30
