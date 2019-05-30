#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then


MarkDuplicates.sh $1
samtools index $1.Dedupping.bam
samtools flagstat $1.Dedupping.bam > $1.Dedupping.bam.flagstats

samtools index $1.Dedupping.Mark.bam
samtools flagstat $1.Dedupping.Mark.bam > $1.Dedupping.Mark.bam.flagstats

GenomeAnalysisTK.DepthOfCoverage.sh $1.Dedupping.bam

DIR=$(dirname $1)

#AlignmentStatisticsReport.sh `ls | egrep "(flagstats|bam.Mark.MarkDuplicatesMetrics|report.sample_cumulative_coverage_counts|report.sample_summary)$" | sort`

AlignmentStatisticsReport.sh `find $DIR -maxdepth 1 -L | egrep "(flagstats|bam.Mark.MarkDuplicatesMetrics|report.sample_cumulative_coverage_counts|report.sample_summary)$" | sort`

else
	usage "xxx.fastq.gz.trim.fastq.sai.sort.mergepe.sort.rg.bam"
fi

