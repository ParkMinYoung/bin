#!/bin/sh

. ~/.bash_function


if [ $# -eq 1 ];then

BED=/home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf.bed
bamToBed -i $1 -split | cut -f1-4 | intersectBed -a stdin -b $BED -wao > $1.miRNA

elif [ $# -eq 2 ];then

BED=$2
bamToBed -i $1 -split | cut -f1-4 | intersectBed -a stdin -b $BED -wao > $1.miRNA

else

	usage "XXX.bam [YYY.gtf.bed]"
fi

