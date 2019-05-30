 

batch.SGE.sh fastq.gz.IsFilter.sh `find | grep fastq.gz$ | sort` > 0.5IsFilter
batch.chagename.sh IsFilter 0.5IsFilter
sh 0.5IsFilter
waiting IsFilter

seq.stat.sh `find | grep fastq.gz$ | sort`

batch2.SGE2.sh GATK.Pipeline.2.sh `find | grep N.fastq.gz$ | sort` | perl -nle'if(/^qsub/){/\.(\d+)\//;$_="$_ $1 2"}print' > 01.Alignment
batch.chagename.sh Alignment 01.Alignment
sh 01.Alignment

sleep 18000
batch.SGE.sh fastqc `find | grep N.fastq.gz$`  > 02.fastqc
sh 02.fastqc

waiting Alignment

GetMappingSeq.assist.sh ` find | egrep "(N.fastq.gz|trimed|single|Dedupping.bam)"$ | sort `
mv GetMappingSeq.script 04.GetMappingSeq
sh 04.GetMappingSeq
waiting GetMap
GetMappingSeq.summary.sh

FastqReadCount.KNIH.sh FastqReadCount

batch.SGE.sh GetDepthCov.sh `find | grep ing.bam$` > 05.GetDepCov
batch.chagename.sh GetDepCov 05.GetDepCov
sh 05.GetDepCov
waiting GetDepCov
GetDepthCov.summary.sh
