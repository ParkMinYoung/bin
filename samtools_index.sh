#!/bin/bash

. ~/.bash_function

BAM=$1
BAI=${BAM%%.bam}.bai

if [ -f "$BAM" ] ;then

	if [ ! -f "$BAI" ];then

		echo "$BAM index process"
		samtools index $BAM
		mv $BAM.bai $BAI
	else
		
		echo "$BAM index skip"
	fi

else
	
	usage "input.BAM"
	
fi
