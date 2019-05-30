#!/bin/sh

source ~/.bash_function
		
		PID=$$

		DIR=
        FASTQ_ALL_LIST=$(find $DIR | grep fastq.gz$ | sort)
        FASTQ_N_LIST=$(find $DIR | grep N.fastq.gz$ | sort)

        #for i in ${FASTQ_N_LIST[@]};do echo $i;done
		
#seq.stat.sh ${FASTQ_ALL_LIST[@]} 

 	 	#batch2.SGE2.sh SNU.BLab.pipeline.v2.script.sh `find | grep N.fastq.gz$ | sort` > 01.Alignment	
		batch2.SGE2.sh ngs.pipeline.v1.sh ${FASTQ_N_LIST[@]} | perl -nle'if(/^qsub/){/(.+)?\/(.+)_\w{6,8}_L00/;$_="$_ $2 2"}print' > 01.Alignment

        batch.chagename.sh A$PID 01.Alignment
		sh 01.Alignment

		sleep 18000
        batch.SGE.sh fastqc ${FASTQ_N_LIST[@]}  > 02.fastqc
        sh 02.fastqc
        waiting A$PID

        BAM_LIST=$(find $DIR | grep ing.bam$ | sort)
		GetMappingSeq.assist.hg19SNU.sh ` find | egrep "(N.fastq.gz|trimmed|single|TableRecalibration.bam)"$ | sort `
        mv GetMappingSeq.script 04.GetMappingSeq
        sh 04.GetMappingSeq
        waiting GetMap
        GetMappingSeq.summary.sh
 
        FastqReadCount.KNIH.V2.sh FastqReadCount
 
        batch.SGE.sh GetDepthCov.sh `find $DIR | grep TableRecalibration.bam$ | sort` > 05.GetDepCov
        batch.chagename.sh G$PID 05.GetDepCov
        sh 05.GetDepCov
        waiting G$PID
        GetDepthCov.summary.sh
 
 
        mkdir summary
        mv Fastq* mapping.summary.txt seq.summary.txt DepthCoverage.txt summary 

