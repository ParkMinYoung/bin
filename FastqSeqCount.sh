#!/bin/sh

source ~/.bash_function


if [ -f "$1" ];then

	date >> FastqSeqCount

	for i in $@
		do 

		EXT=$(perl -sle'$f=~/\.(\w+)?$/;print $1' -- -f=$i)
		
		if [ $EXT == "gz" ];then
			SEQ=$(zcat $i | sed -n 2~4p | awk '{s+=length}END{print s}')
		else
			SEQ=$(sed -n 2~4p $i | awk '{s+=length}END{print s}')
		fi
		
		
		echo -ne "$SEQ\t$i\n" >> FastqSeqCount

		done
else
	usage "XXX.fastq{.gz} YYY.fastq{.gz} ..."
fi
