#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ];then
	LINES=$(($2*4))
	zcat $1 | head -${LINES} | gzip >  $1.$2.gz
else
	usage "xxx.fastq.gz 1000"
fi

# gzip -c $NAME.2.fastq > $NAME.2.fastq.gz
# preserve original $NAME.2.fastq
# gzip $NAME.2.fastq 
# create $NAME.2.fastq.gz
