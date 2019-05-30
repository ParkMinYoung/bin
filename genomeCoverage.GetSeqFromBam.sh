#!/bin/sh

source ~/.bash_function
source ~/.GATKrc
GATK_param

if [ -f "$1" ] ;then

	genomeCoverageBed -ibam $1 -g $REF_GENOME > $1.genomeCoverage
	echo -ne "$1.genomeCoverage\t$(genomeCoverage.GetSeq.sh $1.genomeCoverage)" > $1.seq

else
	usage "xxxx.bam" 
fi


