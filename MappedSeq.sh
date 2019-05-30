#!/bin/sh

source ~/.bash_function

 
#GetMappingSeq.assist.single.sh `find bms.raindance.samsung* | egrep "(fastq.gz|cutadapt|IndelRealigner.bam)"$ | sort`
	GetMappingSeq.assist.single.sh `find Project_* | egrep "(N.fastq.gz|single.fastq|ing.bam)"$ | sort` 
	
 	mv GetMappingSeq.script 04.GetMappingSeq
 	sh 04.GetMappingSeq
 	waiting GetMap
 	GetMappingSeq.summary.sh
 
 	
 	batch.SGE.sh GetDepthCov.sh `find Project_* | grep ing.bam$` > 05.GetDepCov
 	batch.chagename.sh GetDepCov 05.GetDepCov
 	sh 05.GetDepCov
 	waiting GetDepCov
 	GetDepthCov.summary.sh
 
 	mkdir summary
 	mv FastqReadCount* mapping.summary.txt seq.summary.txt DepthCoverage.txt summary 



