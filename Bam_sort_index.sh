#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	samtools sort -o $1.sort.bam $1
	samtools index $1.sort.bam

else
	
	usage "BAM"
fi



