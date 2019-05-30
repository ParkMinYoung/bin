#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BCL2Fastq=configureBclToFastq.pl

Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ $# -ge 1 ];then

	SampleSheet=$1
	
	D_dir=$2
	DIR=${D_dir:=UnAligned}

	D_job=$3
	J=${D_job:=20}

	$Script --input-dir $PWD --intensities-dir $PWD/../ --sample-sheet $SampleSheet --positions-format .clocs --output-dir $DIR >& $BCL2Fastq.log
	cd $DIR
	nohup make -j $J
else
	echo "SampleSheet.csv UnAligned 20"
	usage "SampleSheet.csv [OutDir:UnAligned] [job:20]"
fi

