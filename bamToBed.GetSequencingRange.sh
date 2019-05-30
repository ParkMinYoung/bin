#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] ;then
    
	T=$2
	D=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.NumChr.bed
	Target=${T:=$D}
	Name=$(basename $Target)

#bamToBed -i $1 -split | mergeBed -i stdin > $1.SequencingRange.bed
	bamToBed -i $1 | mergeBed -i stdin > $1.SequencingRange.bed
	intersectBed -a $1.SequencingRange.bed -b $Target -wo > $1.SequencingRange.bed.$Name

else
		usage "sorted.bam Target[SureV2]"
fi

