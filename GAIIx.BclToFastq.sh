#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BCL2Fastq=configureBclToFastq.pl

Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ $# -eq 2 ] && [ -f "$2" ] ;then
	DIR=$1
	SampleSheet=$2

	$Script --input-dir $PWD --intensities-dir $PWD/../ --positions-format _pos.txt --fastq-cluster-count 200000000 --output-dir $DIR --sample-sheet $SampleSheet --ignore-missing-stats --ignore-missing-bcl >& $BCL2Fastq.log
	cd $DIR
	nohup make -j 20 


	declare -a LIST

	LIST=$(find Project_* | grep fastq.gz$ | sort) 
	# echo $LIST
	# echo " out ${LIST[1]} "


	# for i in ${LIST[@]}; do echo $i; done

	FastqReadCount.sh ${LIST[@]} &
	FastqSeqCount.sh ${LIST[@]} &

	fastqc.batch.sh ${LIST[@]} &
	GetFastqInfo.batch.sh ${LIST[@]} >& GetFastqInfo.batch.sh.log


#  batch2.SGE.sh sickle.sh ${LIST[@]} > sickle.batch.sh
#  sh sickle.batch.sh
#  perl -le'while($l=`qstat -u adminrig`){ $l=~/lane/ ? sleep 10 : print localtime()." " & exit}'


#   batch.SGE.sh GetSamtoolsStat.sh ${LIST[@]} > GetSamtoolsStat.sh.batch
#   sh GetSamtoolsStat.sh.batch
#   perl -le'while($l=`qstat -u adminrig`){ $l=~/lane/ ? sleep 10 : print localtime()." " & exit}'
#   flagstat.parsing.sh `find | grep flagstats$`

	mkdir summary && mv Means.txt Qscore.txt FastqReadCount FastqSeqCount reads.summary summary
	mvlog



#	SampleFastq=$(find -maxdepth 1 -type d | grep Project)
#	cd $SampleFastq
	
#	FastqReadCount.sh `find | grep gz$ | sort` &
#	FastqSeqCount.sh `find | grep gz$ | sort` &

#	find | grep gz$ | sort | xargs -n 2 |perl -nle'/lane\d/;print "qsub -N $& ~/src/short_read_assembly/bin/sub Trim2Bwa.Pig.sh $_\nsleep 20" ' > PE.batch.sh
#	sh PE.batch.sh
	
#	batch2.SGE.sh sickle.sh `find | grep fastq.gz$ | sort` > sickle.batch.sh
#	sh sickle.batch.sh

#	fastqc.batch.sh `find Sample_lane* | grep fastq.gz$` &
#	GetFastqInfo.batch.sh `find Sample_lane* | grep fastq.gz$` >& GetFastqInfo.batch.sh.log

## wait for sickle and GetSamtoolsstat
#	perl -le'while($l=`qstat -u adminrig`){ $l=~/lane/ ? sleep 10 : print localtime()." " & exit}'

#	batch.SGE.sh GetSamtoolsStat.sh `find Sample_lane? | grep bam$` > GetSamtoolsStat.sh.batch
#	sh GetSamtoolsStat.sh.batch
	
#	perl -le'while($l=`qstat -u adminrig`){ $l=~/lane/ ? sleep 10 : print localtime()." " & exit}'
#	flagstat.parsing.sh `find | grep flagstats$`

#	mkdir summary && mv Means.txt Qscore.txt read.summary trimmed.sequences.txt summary
#	mvlog

else
	usage "output_dir SampleSheet.csv"
fi



