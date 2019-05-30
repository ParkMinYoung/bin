#!/bin/sh

source ~/.bash_function
if [ -f "$1" ];then

	samtools view $1 | perl -F'\t' -anle'chop($F[0]) && print $F[0] if $F[5] ne "8"' | sort | uniq > $1.MappedRead
else
	usage "XXX.bam"
fi

