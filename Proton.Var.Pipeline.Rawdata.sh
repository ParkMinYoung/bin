#!/bin/sh

. ~/.bash_function

if [ -f "batch" ] ;then

BAM=BAM
VAR=VAR
FASTQ=FASTQ

mkdir $BAM $FASTQ $VAR



		VCFLIST=VCFList.`date +%Y%m%d`
		BAMLIST=BAMList.`date +%Y%m%d`
		FASTQLIST=FASTQList.`date +%Y%m%d`

		# VCF
		for i in `cat batch`;
				do
				find ../$i/Analysis/VAR -type f | grep vcf$ | xargs -i readlink -f {} | grep -v TSVC

		done > $VCFLIST

		# BAM
		for i in `cat batch`;
				do
				find ../$i/Analysis/BAM -type f | grep bam$ | xargs -i readlink -f {} 

		done > $BAMLIST
		
		# FASTQ
		for i in `cat batch`;
				do
				find ../$i/Analysis/FASTQ -type f | grep fastq$ | xargs -i readlink -f {} 

		done > $FASTQLIST

	ln `cat $VCFLIST` $VAR
	ln `cat $BAMLIST` $BAM
	ln `cat $FASTQLIST` $FASTQ

	batch.SGE.sh cat2gz.sh $FASTQ/*fastq > 01.cat2gz.sh
	sh 01.cat2gz.sh >& /dev/null

	mvlog

else
		usage "Check the batch file"
fi

