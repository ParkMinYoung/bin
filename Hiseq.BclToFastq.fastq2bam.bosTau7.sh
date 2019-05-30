#!/bin/sh

source ~/.bash_function

	PID=$$
	T=4 # thread = 2

	#DIR=
	FASTQ_ALL_LIST=$(find $DIR | grep fastq.gz$ | sort)
	FASTQ_N_LIST=$(find $DIR | grep fastq.gz$ | sort)
	
	#for i in ${FASTQ_N_LIST[@]};do echo $i;done

 	seq.stat.sh ${FASTQ_ALL_LIST[@]} 

  	batch2.SGE${T}.sh GATK.Trim2Bwa.cow.sh  ${FASTQ_N_LIST[@]} | perl -snle'if(/^qsub/){/(.+)?\/(.+)_\w{6,8}_L00/;$_="$_ $T 32 2"}print' -- -T=${T}> 01.Alignment
  	batch.chagename.sh A$PID 01.Alignment
  	sh 01.Alignment
 
	batch.SGE.sh fastqc ${FASTQ_N_LIST[@]}  > 02.fastqc
	sh 02.fastqc
 	
	SeqSummary.sh
	flagstat.parsing.v2.sh

		   
