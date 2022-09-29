#!/usr/bin/env bash

#===================#
# Download Datasets #
#===================#

mkdir reference illumina ont pacbio

# Download the CHM13 v1.0 draft
wget -P reference wget -P reference https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chm13.draft_v1.0.fasta.gz
gzip -dc reference/chm13.draft_v1.0.fasta.gz > reference/chm13.draft_v1.0.fasta

N_LINES=10000
REFERENCE=reference/chm13.draft_v1.0.fasta

function download_bam {
  N_LINES=${1}
  DIRECTORY=${2}
  URL=${3}
  curl -P ${DIRECTORY} ${URL} | \
  samtools view -h | \
  head -n ${N_LINES} | \
  samtools view -bh > ${DIRECTORY}/$(basename ${URL})
}

# Illumina
download_bam 100000 illumina https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/alignments/chm13.draft_v1.0.pcrfree.bam

# ONT
download_bam 1000 ont https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/alignments/chm13.draft_v1.0.ont_guppy_3.6.0.wm_2.01.pri.bam

# PacBio HiFi
download_bam 10000 pacbio https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/alignments/chm13.draft_v1.0.hifi_20k.wm_2.01.pri.bam

#==========#
# Run Best #
#==========#

best illumina/chm13.draft_v1.0.pcrfree.bam ${REFERENCE} illumina/illumina
best ont/chm13.draft_v1.0.ont_guppy_3.6.0.wm_2.01.pri.bam ${REFERENCE} ont/ont
best pacbio/chm13.draft_v1.0.hifi_20k.wm_2.01.pri.bam ${REFERENCE} pacbio/pacbio