#!/bin/sh

source ~/.bash_function


if [ -f "$1" ];then
	ADAPTOR=/home/adminrig/src/UC.David.Trim/vsbuffalo-scythe-fb82722/solexa_adapters.fa
	IN=$1
	scythe -a $ADAPTOR -m $IN.match -o $IN.scythe.trimmed.fastq $IN >& $IN.scythe.trimmed.fastq.log
else
	usage "XXX.fastq{.gz}"
fi

