#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	zcat $1 | fastx_trimmer -f 11 -l 91 -Q33 -i - -o $1.trimmerF10L10.gz -z 
#fastx_trimmer -f 11 -l 91 -i $1 -o $1.trimmerF10L10.gz -z 

else
	usage "XXX.fastq{.gz}"
fi

