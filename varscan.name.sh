#!/bin/bash

. ~/.bash_function
. ~/.GATKrc



NORM=$1
TUMOR=$2
OUT_PREFIX=$3
SOMATIC_PVAL=$4
TUMOR_PURITY=$5



if [ -f "$1" ] && [ -f "$2" ] && [ $# -ge 5 ];then
		echo "$0 $@" 

		REF=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.fasta.ShortID
#VARSCAN=/home/adminrig/src/VarScan/VarScan.v2.2.11.jar
		VARSCAN=/home/adminrig/src/VarScan/VarScan.v2.2.5.jar
		TMPDIR=$PWD
		JMEM16=-Xmx16g
		VarScan="java $JMEM16 -Djava.io.tmpdir=$TMPDIR -jar $VARSCAN"


		DIR=$(dirname $NORM)
		OUT_PREFIX=$DIR/varscan

		$VarScan somatic $NORM $TUMOR $OUT_PREFIX \
		  --min-coverage-normal 10        \
		  --min-coverage-tumor 6          \
		  --min-var-freq 0.25             \
		  --min-freq-for-hom 0.80         \
		  --normal-purity 1.00            \
		  --tumor-purity $TUMOR_PURITY    \
		  --somatic-p-value $SOMATIC_PVAL \
		  --p-value 0.99                  \
		  --strand-filter 1               \
		  --output-snp $OUT_PREFIX.$6.snp	  \
		  --output-indel $OUT_PREFIX.$6.indel  \
		  1> $OUT_PREFIX.$6.log 2> $OUT_PREFIX.$6.err
else
		usage "normal.bam tumor.bam output_file_prefix 0.05(pvalue) cellularity(0.7)"
fi


