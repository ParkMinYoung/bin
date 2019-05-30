#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
		

FILE=$1
SNP=$FILE.SelectVariants.SNP.vcf

GenomeAnalysisTK.SelectVariants $FILE 

GATK.vcfFilter.sh $SNP 10 50 1 > $SNP.DP10GQ50SN1.vcf

vcf2GT.sh $SNP.DP10GQ50SN1.vcf > $SNP.DP10GQ50SN1.vcf.geno

perl -nle'@N=$_=~/(NN)/g; print if @N < 5' $SNP.DP10GQ50SN1.vcf.geno > $SNP.DP10GQ50SN1.vcf.geno.NN5


else
	usage "XXX.vcf"
fi

