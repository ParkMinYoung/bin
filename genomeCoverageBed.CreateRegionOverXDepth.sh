#!/bin/sh

source ~/.GATKrc
source ~/.bash_function

if [ -f "$1" ] & [ $# -ge 1 ];then
	
	INTERVAL=$2
	SureSelectNUMBED=${INTERVAL:=$SureSelectNUMBED}

	genomeCoverageBed -ibam $1 -g $REF_GENOME -bg > $1.genomeCoverage

	for i in 1 5 10 15 20 25 30
		do 
			DIR=DP$i
			if [ ! -d $DIR ];then
				mkdir $DIR
			fi

			perl -F'\t' -asnle'print if $F[3] >= $DP' -- -DP=$i $1.genomeCoverage > $1.genomeCoverage.X$i.bed
			intersectBed -a $1.genomeCoverage.X$i.bed -b $SureSelectNUMBED | sortBed -i stdin | mergeBed -i stdin > $1.genomeCoverage.X$i.merge.bed
			coverageBedV2.sh $1.genomeCoverage.X$i.merge.bed $SureSelectNUMBED

			mv $1.genomeCoverage.X$i* $DIR
	done


else
	usage "xxx.bam [intervals]"
fi

