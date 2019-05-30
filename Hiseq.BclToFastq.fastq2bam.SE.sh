#!/bin/sh

source ~/.bash_function

 	seq.stat.sh `find  | grep fastq.gz$ | sort` 

  	batch.SGE.sh GATK.Pipeline.2.SE.sh `find  | grep N.fastq.gz$ | sort` | perl -nle'if(/^qsub/){/(.+)?\/(.+)_\w{6}_L00/;$_="$_ $2 2"}print' > 01.Alignment
#batch2.SGE2.sh GATK.Pipeline.2.sh `find Project_KNIH.set* | grep N.fastq.gz$ | sort` | perl -nle'if(/^qsub/){/Sample_(.+?)\//;$_="$_ $1 2"}print' > 01.Alignment
  	batch.chagename.sh Alignment 01.Alignment
  	sh 01.Alignment
 
	batch.SGE.sh fastqc `find  | grep N.fastq.gz$`  > 02.fastqc
	sh 02.fastqc
 	
 	waiting Alignment
 
	GetMappingSeq.assist.single.sh `find | egrep "(fastq.gz|single.fastq|IndelRealigner.bam)"$`
	#GetMappingSeq.assist.single.sh `find | egrep "(fastq.gz|single.fastq|Dedupping.bam)"$`
	
 	mv GetMappingSeq.script 04.GetMappingSeq
 	sh 04.GetMappingSeq
 	waiting GetMap
 	GetMappingSeq.summary.sh
 
#FastqReadCount.KNIH.sh FastqReadCount
	FastqReadCount.KNIH.V2.sh FastqReadCount
 	
 	batch.SGE.sh GetDepthCov.sh `find | grep IndelRealigner.bam$` > 05.GetDepCov
 	batch.chagename.sh GetDepCov 05.GetDepCov
 	sh 05.GetDepCov
 	waiting GetDepCov
 	GetDepthCov.summary.sh
 
 
 	mkdir summary
 	mv FastqReadCount* mapping.summary.txt seq.summary.txt DepthCoverage.txt summary 
	
	fastc_data.merge.summaryV2.ForInput.Sample.sh
	fastqc.image.mv.default.sh Fastqc.Summary
	cd RawSeqAnalaysis/fastqc_data
	fastc_data.merge.summaryV2.sh ../../Alignment.info.summary set*txt


else
	usage "output_dir SampleSheet.csv"
fi



