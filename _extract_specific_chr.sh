#!/bin/bash

. ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ];then 

	BAM=$1
	CHR=$2

	OUT_BAM=${BAM%.bam}.$CHR.bam
	OUT_BAI=${BAM%.bam}.$CHR.bai
	OUT_BAI2=${BAM%.bam}.$CHR.bam.bai

	samtools view -b $BAM -o $OUT_BAM $CHR
	samtools index -b $OUT_BAM $OUT_BAI

	cp $PWD/$OUT_BAI $OUT_BAI2
else
	usage "BAM CHR"
fi

