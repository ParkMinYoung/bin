#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
	
# VCF2EachSamplesVCF.sh $1
	
	ls $1.*.vcf | perl -nle'/DNALink.PE.(.+)\.vcf/;print "./VCF2PGSNP.sh $_ $1 > $_.PGSNP"' > PGSNP.sh
	sh PGSNP.sh
		
else
	usage "XXX.vcf"
fi
