#!/bin/sh

source ~/.bash_function

if [ $# -gt 2 ];then

T=$1
shift
for i in $@; do echo "zcat $i | fastx_trimmer -i - -o $i.$T.trimmed.gz -z -t $T";done

else
	usage "26 xxx.fastq.gz yyy.fastq.gz ..."
fi

## read length 101
## if T is 26, read length will be 75



