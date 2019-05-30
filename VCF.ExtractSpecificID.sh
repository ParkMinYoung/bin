#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ];then

	VCF=$1
	SAM=$2

	COL=$( head -1000 $VCF |  grep ^#CHR | tr "\t" "\n" | grep -w -n $SAM | cut -d":" -f1 )
	cut -f1-9,$COL $VCF > $SAM.vcf
else
	usage "VCF SampleID"
fi

