#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
	
#head -1000 $1 | grep "#CHR" | cut -f10- | tr "\t" "\n" > $1.SampleName
#for i in `cat $1.SampleName`;do GenomeAnalysisTK.SelectVariantsFromSample.All $1 $i;done

	parallel --bar -k --joblog .GATK3.selectvariants.log GATK3.selectvariants.sh $1 {} ::: $(vcf.sample.sh $1)
else
	usage "XXX.vcf"
fi
