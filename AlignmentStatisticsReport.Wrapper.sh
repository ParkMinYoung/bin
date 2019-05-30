FILE=$1
DIR=$(dirname $1)

##$1 is indelrealigner.bam

# MarkDuplicates.sh $FILE

# indelrealigner
# MarkDuplicates.Mark.sh $FILE
samtools index $FILE.Dedupping.Mark.bam
samtools flagstat $FILE.Dedupping.Mark.bam > $FILE.Dedupping.Mark.bam.flagstats

# indelrealigner
samtools index $FILE.Dedupping.bam
samtools flagstat $FILE.Dedupping.bam > $FILE.Dedupping.bam.flagstats


NEW=$FILE.Dedupping.bam.IndelRealigner.bam.TableRecalibration.bam
OLD=$FILE.Dedupping.bam

if [ -f $NEW ];then
	GenomeAnalysisTK.DepthOfCoverage.sh $NEW
else
	GenomeAnalysisTK.DepthOfCoverage.sh $OLD
	#GenomeAnalysisTK.DepthOfCoverage.HY.sh $OLD
fi


# AlignmentStatisticsReport.sh *flagstats *.bam.Mark.MarkDuplicatesMetrics *.sample_cumulative_coverage_counts *.sample_summary
AlignmentStatisticsReport.sh `find $DIR -maxdepth 1 | egrep "(flagstats|bam.Mark.MarkDuplicatesMetrics|sample_cumulative_coverage_counts|sample_summary)$" | sort`

