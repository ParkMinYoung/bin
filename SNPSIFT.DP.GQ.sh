#!/bin/sh

. ~/.bash_function

if [ $# -eq 3 ]; then

	cat $1 | java -jar /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar filter "( GEN[ALL].DP >= $2 ) & ( GEN[ALL].GQ >= $3 )" > $1.DP$2.GQ$3.vcf
else
	usage "XXX.vcf DP[30] GQ[50]"
fi


