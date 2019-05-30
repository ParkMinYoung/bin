#!/bin/sh

. ~/.bash_function

if [ -f "$1" ]; then

STAR_REF_DIR=/home/adminrig/Genome/STAR.Genome/Arabidopsis_thaliana
REF_IN=$2
REF_DIR=${REF_IN:=$STAR_REF_DIR}

OUT=$1.star

STAR --runMode alignReads --genomeLoad LoadAndRemove --genomeDir $REF_DIR --runThreadN 10 --outFileNamePrefix $OUT --outSAMmode Full --readFilesIn $1

else
	usage "XXX.fastq [STAR_INDEXED_REF_DIR]"
fi

