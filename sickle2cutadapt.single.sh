#!/bin/sh

source ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ] ;then

	R1=$1
	R1_trim=$R1.trimed.fastq

	Quality=$3
	Length=$4

	Q=${Quality:=20}
	L=${Length:=1}

	 sickle se -f $R1 -q $Q -t illumina 20 -l $L -o $R1_trim
	#sickle pe -f $R1 -r $R2 -q $Q -t illumina -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
	 cutadapt.v2.sh $R1_trim &

#sickle pe -f $R1 -r $R2 -q $Q -t sanger -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
else
	usage "R1.fastq{.gz} [quality 20] [length 1]"
fi

