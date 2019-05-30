#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_3Q/

snpeff="java -Xmx32g -jar $SNPEFF_DIR/snpEff.jar"
snpsift="java -Xmx32g -jar $SNPEFF_DIR/SnpSift.jar"
#snpsift="java -Xmx512g -jar /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar"


if [ -f "$1" ]; then
	
	## snpeff annotation
	$snpeff -i vcf -o vcf -config $SNPEFF_DIR/snpEff.config GRCh37.75 $1 1> $1.snpeff.vcf 2> $1.snpeff.vcf.log

	
	## vcf 2 tab (including redundant annotation)
	snpeff2OPL2TAB.sh $1.snpeff.vcf

	
	## get unique line(from previouse step)
    UniqueLine.sh $1.snpeff.vcf.tab "1,2,3,4,5" ":"	> $1.snpeff.vcf.tab.unique
	

	## reheader
	snpeff_reheader.sh $1.snpeff.vcf.tab.unique
	#AddHeader.sh $1.snpeff.vcf.tab.unique $1.snpeff.vcf.tab.unique.header $( head -1 $1.snpeff.vcf.tab.unique | tr "\t" "\n" | perl -nle's/^(#|(GEN.+|ANN.+)\.)//;print') 

else
	echo -e "\n\n${RED}convert [M] chromosome to [MT] chromsome${NORM} in the input vcf file"
	usage "snpeff.vcf[ANN]"

fi

