#!/bin/bash

#SBATCH --job-name=buscoV
#SBATCH --mem=200G
#SBATCH --cpus-per-task=20
#SBATCH --account=5-39268
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/busco/buscoV95.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/busco/buscoV95.err

spack load singularityce
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

export TDIR=$(mktemp -d)
cp ${MY_FOLDER}/transcriptome_assembly/evigene_final/cdhit/Abar_trinity_spades.95.unitigs.fasta \
    ${TDIR}
pushd ${TDIR}

singularity run --bind ${TDIR}:${TDIR},/work:/work ${MY_FOLDER}/busco_v5.4.7_cv1.sif busco \
	-i ${TDIR}/Abar_trinity_spades.95.unitigs.fasta  \
	-l vertebrata_odb10 \
	-o abar_vert_cdhit95 -m transcriptome -c 90

popd
cp -a ${TDIR}/abar_vert_cdhit95/ \
    ${MY_FOLDER}/transcriptome_assembly/evigene_final/busco/
rm -rf ${TDIR}
