#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ];then

	samtools view -bo $1.$2.bam $1 $2
	samtools sort -n $1.$2.bam $1.$2.bam.SortByName

else
	usage "xxx.bam chr5[:1-1000]"
fi


