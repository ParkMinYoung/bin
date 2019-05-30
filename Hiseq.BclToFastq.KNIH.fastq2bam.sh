#!/bin/sh

source ~/.bash_function

#BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BIN=/home/adminrig/bin
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
 	nohup make -j 20 

	for i in `find Project_* | grep fastq.gz$`;do mv $i $i.N.fastq.gz ;done

	#batch.SGE.sh fastq.gz.IsFilter.sh `find Project_* | grep fastq.gz$ | sort` > 0.5IsFilter
	#batch.chagename.sh IsFilter 0.5IsFilter
	#sh 0.5IsFilter
	#waiting IsFilter

 	seq.stat.sh `find Project_* | grep fastq.gz$ | sort` 

  	batch2.SGE2.sh GATK.Pipeline.2.sh `find Project_KNIH.set* | grep N.fastq.gz$ | sort` | perl -nle'if(/^qsub/){/Sample_(.+?)\//;$_="$_ $1 2"}print' > 01.Alignment
  	batch.chagename.sh Alignment 01.Alignment
  	sh 01.Alignment
 
	sleep 18000	
	batch.SGE.sh fastqc `find Project_KNIH.set* | grep N.fastq.gz$`  > 02.fastqc
	sh 02.fastqc
 	
 	waiting Alignment
 
 	GetMappingSeq.assist.sh ` find Project_KNIH.set* | egrep "(N.fastq.gz|trimed|single|Dedupping.bam)"$ | sort ` 
 	mv GetMappingSeq.script 04.GetMappingSeq
 	sh 04.GetMappingSeq
 	waiting GetMap
 	GetMappingSeq.summary.sh
 
#FastqReadCount.KNIH.sh FastqReadCount
	FastqReadCount.KNIH.V2.sh FastqReadCount
 	
 	batch.SGE.sh GetDepthCov.sh `find Project_KNIH.set* | grep ing.bam$` > 05.GetDepCov
 	batch.chagename.sh GetDepCov 05.GetDepCov
 	sh 05.GetDepCov
 	waiting GetDepCov
 	GetDepthCov.summary.sh
 
 	fastqc.image.mv.default.sh	
 
 	mkdir summary
 	mv FastqReadCount* mapping.summary.txt seq.summary.txt DepthCoverage.txt summary 
	
	fastc_data.merge.summaryV2.ForInput.sh
	fastqc.image.mv.default.sh Fastqc.Summary
	cd RawSeqAnalaysis/fastqc_data
	fastc_data.merge.summaryV2.sh ../../Alignment.info.summary set*txt

	GetQscore.summary.batch.sh

else
	usage "output_dir SampleSheet.csv"
fi



