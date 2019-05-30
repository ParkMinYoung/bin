#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

INTERVAL=$1
SIZE=$2
BINSIZE=${SIZE:=1000}


Intervals2genome.sh $INTERVAL > $INTERVAL.genome
chr.bin.sh $INTERVAL.genome $BINSIZE
perl -nle's/(:|-)/\t/g;print' $INTERVAL | intersectBed -a stdin -b $INTERVAL.genome.bin$BINSIZE.bed > $INTERVAL.bin$BINSIZE.bed

else
	usage "XXX.intervals [ 1000 ]"
fi

