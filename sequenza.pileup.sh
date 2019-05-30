#!/bin/bash


. ~/.bash_function

if [ -f "$1" ]; then

	output=${2:-$1.pileup.gz}
	samtools mpileup -f $b37 -Q 20 $1 | gzip > $output

else	

	usage "XXX.bam [output_name_with_.pileup.gz]: XXX.bam.pileup.gz" 

fi


