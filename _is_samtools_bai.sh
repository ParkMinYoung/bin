#!/bin/bash 

. ~/.bash_function

if [ -f "$1" ];then

	BAM=$1
	BAI=${BAM%.bam}.bai
	BAI2=${BAM}.bai

	if [ -f "$BAI" ];then
		
		if [ ! -f "$BAI2" ];then
			
			cp $BAI $BAI2

		fi

	else
		
		samtools index -b $BAM $BAI	
		cp -f $BAI $BAI2
	fi

else
	
	usage "target.bam"

fi

