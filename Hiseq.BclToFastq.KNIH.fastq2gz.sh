#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BCL2Fastq=configureBclToFastq.pl

Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ $# -eq 2 ] && [ -f $2 ] ;then
	DIR=$1
	SHEET=$2

 	$Script --input-dir $PWD --intensities-dir $PWD/../ --positions-format .clocs --fastq-cluster-count 900000000 --sample-sheet $SHEET --output-dir $DIR >& $BCL2Fastq.log
 	#$Script --input-dir $PWD --intensities-dir $PWD/../ --positions-format .clocs --fastq-cluster-count 200000000 --sample-sheet $SHEET --output-dir $DIR --use-bases-mask Y101,I6n,y75n* >& $BCL2Fastq.log
 	cd $DIR
 	nohup make -j 16 
	
	batch.SGE.sh fastq.gz.IsFilter.sh `find Project_* | grep fastq.gz$ | sort` > 0.5IsFilter
	batch.chagename.sh IsFilter 0.5IsFilter
	sh 0.5IsFilter
	waiting IsFilter

 	seq.stat.sh `find Project_* | grep fastq.gz$ | sort` 

 
	batch.SGE.sh fastqc `find Project_* | grep N.fastq.gz$`  > 02.fastqc
	sh 02.fastqc

	batch.SGE.sh prinseq.sh `find Project_* | grep N.fastq.gz$`  > 03.prinseq
	sh 03.prinseq
 	
	sleep 18000	
 	FastqReadCount.KNIH.sh FastqReadCount
 	fastqc.image.mv.default.sh 
	(cd RawSeqAnalaysis/fastqc_data; fastqc.summary.sh *.txt)

 	mkdir summary
 	mv FastqReadCount* summary 
else
	usage "output_dir SampleSheet.csv"
fi



