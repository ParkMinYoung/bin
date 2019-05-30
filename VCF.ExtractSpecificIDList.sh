#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

	VCF=$1
	SAM=$2

	while IFS=$'\t' read -r col1 col2 ; do
		
		VCF.ExtractSpecificID.sh $VCF $col1;
		VCF.IDChanger.sh $col1.vcf $col2

	done < $SAM 

else
	usage "VCF SampleIDList"
fi

