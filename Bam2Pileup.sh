#!/bin/sh 


source ~/.bash_function
source ~/.GATKrc


if [ $# -ge 1 ] && [ -f "$1" ];then

		SAMTOOLS=/home/adminrig/src/SAMTOOLS/samtools-0.1.16/samtools

		Q=$2
		QScore=${Q:=20}


		# $SAMTOOLS pileup -vcf $REF_Short $1 > $1.pileup
		# $SAMTOOLS pileup -Q 30 -vcf $REF_Short $1 > $1.pileup
		$SAMTOOLS pileup -Q $QScore -f $REF_Short $1 > $1.Q$QScore.pileup
		# $SAMTOOLS pileup -vcf $REF_Short $1 | gzip $1.pileup

else
		usage "Bamfile Qscore[20]"
fi

