#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/bin
BCL2Fastq=configureBclToFastq.pl

Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ $# -eq 2 ] && [ -f $2 ] ;then
	DIR=$1
	SHEET=$2

	$Script --input-dir $PWD --intensities-dir $PWD/../ --positions-format .clocs --fastq-cluster-count 900000000 --sample-sheet $SHEET --use-bases-mask Y101,I6n --output-dir $DIR >& $BCL2Fastq.log
	#$Script --input-dir $PWD --intensities-dir $PWD/../ --positions-format .clocs --fastq-cluster-count 200000000 --sample-sheet $SHEET --output-dir $DIR --use-bases-mask Y101,I6n,y75n* >& $BCL2Fastq.log
	cd $DIR
	nohup make -j 20 

	for i in `find Project_* | grep fastq.gz$`;do mv $i $i.N.fastq.gz ;done


	#batch.SGE.sh fastq.gz.IsFilter.sh `find Project_* | grep fastq.gz$ | sort` > 0.5IsFilter
	#batch.chagename.sh IsFilter 0.5IsFilter	
	#sh 0.5IsFilter
   # waiting IsFilter

	seq.stat.sh `find Project_* Undetermined_indices | grep fastq.gz$ | sort`
	
	# cp Basecall_Stats_dir ~/workspace.min/DNALink.Hiseq
	Hiseq.Basecall_Stats_cp.sh

else
	usage "output_dir SampleSheet.csv"
fi



