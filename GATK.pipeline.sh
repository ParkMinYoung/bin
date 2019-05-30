#!/bin/sh

# find s_? | grep fastq$ | grep sanger | perl -nle'$c="$ENV{PWD}/$_"; s/\.sanger//; `ln -s $c $_`'

bwa.sampe.GATK.sh $1 32 2 >& bwa.sampe.GATK.sh.$1.log    ## output : $1/$1.GATK.bam
## there is MergeSamFiles.sh $1

cd $1
CollectAlignmentSummaryMetrics.sh $1.GATK.bam &
CollectGcBiasMetrics.sh $1.GATK.bam &
CollectInsertSizeMetrics.sh $1.GATK.bam &
EstimateLibraryComplexity.sh $1.GATK.bam &
MeanQualityByCycle.sh $1.GATK.bam &
QualityScoreDistribution.sh $1.GATK.bam &
MarkDuplicates.sh $1.GATK.bam &

