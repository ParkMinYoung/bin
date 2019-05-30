#!/bin/sh

source ~/.bash_function


if [ -f "$1" ] ;then

	R1=$1
	R1_trim=$R1.trimmed.fastq

	Quality=$3
	Length=$4

	Q=${Quality:=20}
	L=${Length:=1}

	sickle se -f $R1 -t illumina -o $R1_trim -l $L -q $Q >& $R1_trim.sickle.se.log

else
	usage "R1.fastq{.gz} [quality 20] [length 1]"
fi

