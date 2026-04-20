#!/bin/bash

#SBATCH --job-name=kraken
#SBATCH --mem=200G
#SBATCH --cpus-per-task=30
#SBATCH --account=5-39268
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mgaupp42@tntech.edu
#SBATCH -o /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/kraken/kraken.out
#SBATCH -e /work/projects/5-39268/mgaupp42/transcriptome_assembly/evigene_final/kraken/kraken.err

spack load kraken2@2.1.2
export MY_FOLDER=/work/projects/5-39268/mgaupp42/
cd ${MY_FOLDER}

export TDIR=$(mktemp -d)
cp ${MY_FOLDER}/transcriptome_assembly/evigene_final/okayset/Abar_trinity_spades.okay.mrna \
    ${TDIR}
pushd ${TDIR}

kraken2 --use-names --threads 90 --confidence 0.1 --classified-out ${TDIR}/Abar_trinity_spades.classified.fa \
	--unclassified-out ${TDIR}/Abar_trinity_spades.unclassified.fa \
	--db ${MY_FOLDER}/maxikraken2_1903_140GB ${TDIR}/Abar_trinity_spades.okay.mrna > ${TDIR}/Abar_trinity_spades.kraken_stats \
# done
popd

cp -a ${TDIR}/Abar_* \
    ${MY_FOLDER}/transcriptome_assembly/evigene_final/kraken/

rm -rf ${TDIR}
