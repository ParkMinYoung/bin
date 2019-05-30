#!/bin/sh
source ~/.bash_function

if [ -f "$1" ];then
	
	if [ ! -f "$1.qual" ];then
		Fasta2qual.sh $1
	fi

	LIB=`echo $1 | perl -MFile::Basename -nle'($f)=fileparse($_);$f=~/(.+)\.f\w+/;print $1'`
	convert-fasta-to-v2.pl -l $LIB -s $1 -q $1.qual > $LIB.frg
else
	usage "XXXX.fasta"
fi
