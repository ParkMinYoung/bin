#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	GATK.vcf2GTsGPsGQsADs.sh $1 > $1.geno
	GATK.vcf2GTsGPsGQsADs2Filter.sh $1.geno > $1.geno.Filter.Sample7DP10GQ50
	GATK.vcf2GTsGPsGQsADs2Filter.sh $1.geno 30 50 7 > $1.geno.Filter.Sample7DP30GQ50
	
	GATK.vcf2ReCalculatorFromVarFreq.sh $1 > $1.RecalculatorFromVarFreq.vcf
	GATK.vcf2GTsGPsGQsADs.sh $1.RecalculatorFromVarFreq.vcf > $1.RecalculatorFromVarFreq.vcf.geno
	GATK.vcf2GTsGPsGQsADs2Filter.sh $1.RecalculatorFromVarFreq.vcf.geno  > $1.RecalculatorFromVarFreq.vcf.geno.Filter.Sample7DP10GQ50
	GATK.vcf2GTsGPsGQsADs2Filter.sh $1.RecalculatorFromVarFreq.vcf.geno 30 50 7 > $1.RecalculatorFromVarFreq.vcf.geno.Filter.Sample7DP30GQ50

	GATK.vcf2DepthDist.sh $1.geno.Filter.Sample7DP10GQ50
else
	usage "XXX.vcf"
fi



