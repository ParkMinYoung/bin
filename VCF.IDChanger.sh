#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ];then
	
	perl -i.bak -sple'if(/^#CHR/){ s/FORMAT\t.+/FORMAT\t$id/ } ' -- -id=$2 $1
	rm -rf $1.bak
	mv -f $1 $2.vcf

else
	usage "XXX.vcf SampleID"
fi

