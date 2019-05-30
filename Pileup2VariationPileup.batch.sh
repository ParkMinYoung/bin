#!/bin/sh 

source ~/.bash_function

SUB=~/src/short_read_assembly/bin/sub

if [ $# -ne 0 ];then

	for i in $@;do echo -e "qsub -N pile2vcf ~/src/short_read_assembly/bin/sub Pileup2VariationPileup.sh $i\nsleep 20";done
else
	usage sorted.bam list
fi

