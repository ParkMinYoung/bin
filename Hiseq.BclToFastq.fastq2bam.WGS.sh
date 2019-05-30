#!/bin/sh

source ~/.bash_function

	PID=$$

	#DIR=
	FASTQ_ALL_LIST=$(find $DIR | grep fastq.gz$ | sort)
	FASTQ_N_LIST=$(find $DIR | grep N.fastq.gz$ | sort)
	
	#for i in ${FASTQ_N_LIST[@]};do echo $i;done

  	batch2.SGE8.sh GATK.Pipeline.2.sh ${FASTQ_N_LIST[@]} | perl -nle'if(/^qsub/){/(.+)?\/(.+)_\w{6,8}_L00/;$_="$_ $2 8"}print' > 01.Alignment
  	batch.chagename.sh A$PID 01.Alignment
  	sh 01.Alignment
 
	sleep 18000	
	batch.SGE.sh fastqc ${FASTQ_N_LIST[@]}  > 02.fastqc
	sh 02.fastqc
 	
 	waiting A$PID
 
 	FastqReadCount.KNIH.V2.sh FastqReadCount
	#FastqReadCount.KNIH.sh FastqReadCount
 	
	
	batch.SGE.sh AlignmentStatisticsReport.Wrapper.sh `find | grep ner.bam$ | sort` > 06.AlignmentStat
	batch.chagename.sh S$PID 06.AlignmentStat
	sh 06.AlignmentStat 
	waiting S$PID
	StatisticsReport.summary.sh	
