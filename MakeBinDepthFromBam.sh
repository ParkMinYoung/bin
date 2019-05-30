#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then


# excute time : 2017-11-16 13:23:59 : get depth using samtools depth
samtools depth $1 > $1.depth 


# excute time : 2017-11-16 13:49:45 : mean depth in the 100bp
perl -F'\t' -anle' print join "\t", $F[0], $F[1]-1, $F[1], $F[2]'  $1.depth | bedtools map -a EBV.bed -b stdin -c 4 -o mean > $1.depth.bin

sed -i '1i\chr\tstart\tend\tdepth' $1.depth.bin

else
	usage "XXX.bam"
fi


