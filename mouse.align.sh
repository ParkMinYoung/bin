#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ] & [ $# -eq 3 ];then

fastq.gz.IsFilter.sh $1 &
fastq.gz.IsFilter.sh $2 &
wait

GATK.Trim2Bwa.Mouse.sh $1.N.fastq.gz $2.N.fastq.gz $3

else
	usage "R1.fastq{.gz} R2.fastq{.gz} id"
fi

