#!/bin/sh

source ~/.bash_function


if [ -f "$1" ] && [ -f "$2" ] ;then

	R1=$1
	R2=$2
	R1_trim=$R1.trimed
	R2_trim=$R2.trimed
	R1_single=$1.single

	Quality=$3
	Length=$4

	Q=${Quality:=20}
	L=${Length:=20}


#sickle pe -f $R1 -r $R2 -q $Q -t illumina -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
	 sickle pe -f $R1 -r $R2 -q $Q -t sanger -l $L -o $R1_trim -p $R2_trim -s $R1_single >& $1_trim.sicle.log 
else
	usage "R1.fastq{.gz} R2.fastq{.gz} [quality 20] [length 1]"
fi

