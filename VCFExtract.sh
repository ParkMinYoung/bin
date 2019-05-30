#!/bin/sh

. ~/.bash_function
. ~/.GATKrc

if [ -f "$1" ];then


	java -jar $ESNPSIFT extractFields $1 CHROM POS ID REF ALT FILTER AB AC AF AN BaseQRankSum DP Dels FS HRun HaplotypeScore InbreedingCoeff MQ MQ0 MQRankSum QD ReadPosRankSum VQSLOD culprit > $1.Extract

else
	usage "xxx.vcf"
fi

