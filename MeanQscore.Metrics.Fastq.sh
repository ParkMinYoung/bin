#!/bin/sh

. ~/.bash_function
#MeanScore=26

if [ $# -eq 3 ];then

qsub_wrapper.sh FASTQ high.q 16 none n /home/adminrig/src/short_read_assembly/bin/MeanQscore.Metrics.Fastq.SGE.sh $3 $1
sleep 10
qsub_wrapper.sh FASTQ high.q 16 none n /home/adminrig/src/short_read_assembly/bin/MeanQscore.Metrics.Fastq.SGE.sh $3 $2


else
	echo "$0 CHET_37T5_CGATGT_L007_R1_001.fastq.gz CHET_37T5_CGATGT_L007_R2_001.fastq.gz CHET_37T5_CGATGT_L007_R1_001.fastq.gz.LinePerQScore.txt" 
	echo "in $@"
	usage "XXX.R1.fastq.gz XXX.R2.fastq.gz XXX.R1.fastq.gz.LinePerQScore.txt" 
fi


