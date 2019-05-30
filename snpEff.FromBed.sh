#!/bin/bash

. ~/.bash_function

default_db=GRCh37.75
default_config=/home/adminrig/src/SNPEFF/snpEff_4_3/snpEff.config
default_snpeff=/home/adminrig/src/SNPEFF/snpEff_4_3/snpEff.jar


if [ -f "$1" ];then


	BED=$1
	DB=${2:-$default_db}
	config=${3:-$default_config}
	eff=${4:-$default_snpeff}

	snpeff="java -Xmx32g -jar $eff"

	$snpeff ann -i bed -config $config $DB $BED > $BED.snpeff

	if [ -f "$4" ]; then
		
		SNPEFF.ChIPSeq2Tab.v4.1.sh $BED.snpeff

	fi


else
	echo "XXX.bed GRCh37.75 /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.config /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar"
	echo "snpEff.FromBed.sh cpgIslandExt.bed GRCh37.75 /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.config /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar"
	usage "XXX.bed [db name] [config] [snpeff]"

fi







