#!/bin/sh

source ~/.bash_function

	PID=$$
	T=2 # thread = 2

	#DIR=
	FASTQ_ALL_LIST=$(find $DIR | grep fastq.gz$ | sort)
	FASTQ_N_LIST=$(find $DIR | grep fastq.gz$ | sort)
	
	#for i in ${FASTQ_N_LIST[@]};do echo $i;done

 	seq.stat.sh ${FASTQ_ALL_LIST[@]} 

  	batch2.SGE${T}.sh GATK.Pipeline.2.sh ${FASTQ_N_LIST[@]} | perl -snle'if(/^qsub/){/(.+)?\/(.+)_\w{6,8}_L00/;$_="$_ $2 $T"}print' -- -T=${T}> 01.Alignment
  	batch.chagename.sh A$PID 01.Alignment
  	sh 01.Alignment
 
	sleep 18000	
	batch.SGE.sh fastqc ${FASTQ_N_LIST[@]}  > 02.fastqc
	sh 02.fastqc
 	
 	waiting A$PID
 
	BAM_LIST=$(find $DIR | grep ing.bam$ | sort)
 	GetMappingSeq.assist.sh ` find | egrep "(N.fastq.gz|trimed|single|Dedupping.bam)"$ | sort ` 
 	mv GetMappingSeq.script 04.GetMappingSeq
 	sh 04.GetMappingSeq
 	waiting GetMap
 	GetMappingSeq.summary.sh
 
 	FastqReadCount.KNIH.V2.sh FastqReadCount
	#FastqReadCount.KNIH.sh FastqReadCount
 	
 	batch.SGE.sh GetDepthCov.sh `find $DIR | grep ing.bam$ | sort` > 05.GetDepCov
 	batch.chagename.sh G$PID 05.GetDepCov
 	sh 05.GetDepCov
 	waiting G$PID
 	GetDepthCov.summary.sh
 
 
 	mkdir summary
 	mv FastqReadCount* mapping.summary.txt seq.summary.txt DepthCoverage.txt summary 
	
	batch.SGE.sh AlignmentStatisticsReport.Wrapper.sh `find | grep ner.bam$ | sort` > 06.AlignmentStat
	batch.chagename.sh S$PID 06.AlignmentStat
	sh 06.AlignmentStat 
	waiting S$PID
	StatisticsReport.summary.sh	

	fastc_data.merge.summaryV2.ForInput.Sample.sh
	fastqc.image.mv.default.Sample.sh	
	cd RawSeqAnalaysis/fastqc_data
	fastc_data.merge.summaryV2.sh ../../Alignment.info.summary *L00?.txt 

	GetQscore.summary.batch.sh

