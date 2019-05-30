#!/bin/sh

. ~/.bash_function

if [ -f "$1" ]; then

	txtfile=$1
	bedfile=${txtfile/%txt/bed}
	snpeff=${bedfile/%bed/snpeff.bed}
	Genome=${2:-GRCh37.75}


	## make DMR bed file : input is already zero based bed file, so dont -1 to $F[1]
	perl -F'\t' -anle'if($.>1){ print join "\t", @F[0..2], (join ";", @F[3,4,6,7,8]) }' $txtfile > $bedfile

	## annotation using DMR bed file
	java -Xmx16G -jar /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar eff -i bed -config /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.config $Genome $bedfile > $snpeff

	## make final files
	SNPEFF.MethylSeqDMR2Tab.v4.1.sh $snpeff


else
	echo " sh -x BiseqSNPEFF2Anno.sh filter.DMR.annot.txt [GRCh37.75:TAIR10.30,...]"
	usage "filter.DMR.annot.txt [GRCh37.75]"
fi

