#!/bin/bash

. ~/.bash_function
. ~/.GATKrc



NORM=$1
TUMOR=$2
OUT_PREFIX=$3
SOMATIC_PVAL=$4
TUMOR_PURITY=$5

Quality=$6
D=20
Q=${Quality:=$D}

PILEUP_NORM=$1.Q$Q.pileup
PILEUP_TUMOR=$2.Q$Q.pileup

if [ -f "$1" ] && [ -f "$2" ] && [ $# -ge 5 ];then
		echo "$0 normal tumor output_file 0.05 cellularity"

		REF=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.fasta.ShortID
		VARSCAN=/home/adminrig/src/VarScan/VarScan.v2.2.11.jar
		TMPDIR=$PWD
		JMEM16=-Xmx16g
		VarScan="java $JMEM16 -Djava.io.tmpdir=$TMPDIR -jar $VARSCAN"

		Bam2Pileup.sh $NORM $Q &
		Bam2Pileup.sh $TUMOR $Q &
		wait

		DIR=$(dirname $NORM)
		OUT_PREFIX=$DIR/$DIR.varscan

		$VarScan somatic $PILEUP_NORM $PILEUP_TUMOR $OUT_PREFIX \
		  --min-coverage-normal 10        \
		  --min-coverage-tumor 6          \
		  --min-var-freq 0.25             \
		  --min-freq-for-hom 0.80         \
		  --normal-purity 1.00            \
		  --tumor-purity $TUMOR_PURITY    \
		  --somatic-p-value $SOMATIC_PVAL \
		  --p-value 0.99                  \
		  --strand-filter 1               \
		  --output-vcf 1				  \
		  1> $OUT_PREFIX.log 2> $OUT_PREFIX.err
else
		usage "normal.bam tumor.bam output_file_prefix 0.05(pvalue) cellularity(0.7)"
fi


