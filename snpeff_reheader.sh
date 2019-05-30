#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	AddHeader.sh $1 $1.header $( head -1 $1 | tr "\t" "\n" | perl -nle's/^(#|(GEN.+|ANN.+)\.)//;print')

else
	usage "XXX.snpeff.vcf.tab"
fi


