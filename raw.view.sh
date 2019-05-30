#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
	bcftools view $1 | vcfutils.pl varFilter -d 10 -D 5000 
	#bcftools view $1 | vcfutils.pl varFilter -d 10 -D 5000 | bcf-fix.pl
else
	usage "XXX.bam.bcf.var.raw"
fi


