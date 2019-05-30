#!/bin/sh

source ~/.GATKrc
source ~/.bash_function

if [ -f "$1" ] & [ $# -ge 1 ];then
	
	INTERVAL=$3
	SureSelectNUMBED=${INTERVAL:=$SureSelectNUMBED}

	NORMAL=$1
	TUMOR=$2

	genomeCoverageBed -ibam $NORMAL -g $REF_GENOME -bg > $NORMAL.genomeCoverage &
	genomeCoverageBed -ibam $TUMOR  -g $REF_GENOME -bg > $TUMOR.genomeCoverage &
	wait

	for i in 1 10 20 30
		do 
			DIR=DP$i
			if [ ! -d $DIR ];then
				mkdir $DIR
			fi

			perl -F'\t' -asnle'print if $F[3] >= $DP' -- -DP=$i $NORMAL.genomeCoverage > $NORMAL.genomeCoverage.X$i.bed &
			perl -F'\t' -asnle'print if $F[3] >= $DP' -- -DP=$i $TUMOR.genomeCoverage > $TUMOR.genomeCoverage.X$i.bed &
			wait

			intersectBed -a $NORMAL.genomeCoverage.X$i.bed -b $SureSelectNUMBED | sortBed -i stdin | mergeBed -i stdin > $NORMAL.genomeCoverage.X$i.merge.bed
			intersectBed -a $TUMOR.genomeCoverage.X$i.bed  -b $SureSelectNUMBED | sortBed -i stdin | mergeBed -i stdin >  $TUMOR.genomeCoverage.X$i.merge.bed
			
			intersectBed -a $NORMAL.genomeCoverage.X$i.merge.bed -b $TUMOR.genomeCoverage.X$i.merge.bed > $NORMAL.genomeCoverage.X$i.IntersecRegionNvsT.bed
			coverageBedV2.sh $NORMAL.genomeCoverage.X$i.IntersecRegionNvsT.bed $SureSelectNUMBED
#intersectBed -a $NORMAL.genomeCoverage.X$i.bed -b $TUMOR.genomeCoverage.X$i.bed | intersectBed -a stdin -b $SureSelectNUMBED | mergeBed -i stdin > $NORMAL.genomeCoverage.X$i.IntersecRegionNvsT.bed
#coverageBedV2.sh $NORMAL.genomeCoverage.X$i.IntersecRegionNvsT.bed $SureSelectNUMBED

			mv $NORMAL.genomeCoverage.X$i* $TUMOR.genomeCoverage.X$i* $DIR
	done


else
	usage "xxx-N.bam xxx.-T.bam [intervals]"
fi

