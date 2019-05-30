#!/bin/sh 

source $HOME/.bash_function

if [ $# -gt 1 ];then
	
	for i in $@;do echo "Bam2Pileup2AlleleCnt.sh $i >& $i.log &";done | sh
else
	usage "XXX.bam [YYY.bam ZZZ.bam ....]"
fi

