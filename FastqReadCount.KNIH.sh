#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -anle'
BEGIN{$ENV{PWD}=~/(\d{6}.+)\/Data/;$batch=$1} 
/(.+)\/(.+)_(\w{6})_(L00\d)_(R\d)/;
print join "\t", $batch,$1,$4,$2,$3,$F[0],$F[0]*2*101,$F[1] if $5 eq "R1"
' $1 | grep N.fastq.gz > $1.R1.KNIH.summary

else
	usage "FastqReadCount"
fi


# Project_KNIH.set38/Sample_Pat1-48-T01/Pat1-48-T01_CGATGT_L001_R1_001.fastq.gz

