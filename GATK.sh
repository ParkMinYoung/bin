#!/bin/sh

if [ $# -lt 1 ] || [ $# -gt 2 ] ; then
	echo "usage : `basename $0` s_1 2 >& GATK.sh.s_1.log &"
	# GATK.sh s_5 2 >& s_5.log &
	exit 0
fi

NumOfTHREAD=1

	if [ $2 ];then
		NumOfTHREAD=$2
	fi
	
	source ~/.GATKrc

	# make *unaligned.bam file from *fastq.gz
	 Fastq.gzToSam.sh $1 >& Fastq.gzToSam.sh.$1.log 

	# make paired end *sanger.{1,2}.fastq.gz file from *unaligned.bam
	 SamToFastq.sh $1/$1.unalign.bam

	# accomplish [bwa sample] 
	# must be fastq format because of Trimming(Trim.pl)
	# bwa.sampe.GATK.sh $1 32 2 $1/$1.sanger.1.fastq.gz $1/$1.sanger.2.fastq.gz $NumOfTHREAD  ## output : $1/$1.GATK.bam
	bwa.sampe.GATK.sh $1 32 2 $1/$1.sanger.1.fastq $1/$1.sanger.2.fastq $NumOfTHREAD  ## output : $1/$1.GATK.bam

	# GATK 
	CollectAlignmentSummaryMetrics.sh $1/$1.GATK.bam 
	CollectGcBiasMetrics.sh $1/$1.GATK.bam 
	CollectInsertSizeMetrics.sh $1/$1.GATK.bam 
	EstimateLibraryComplexity.sh $1/$1.GATK.bam 
	MeanQualityByCycle.sh $1/$1.GATK.bam 
	QualityScoreDistribution.sh $1/$1.GATK.bam 
	
	MarkDuplicates.sh $1/$1.GATK.bam 
	#SortSam.sh $1/$1.GATK.bam.Dedupping.bam

	GenomeAnalysisTK.RealignerTargetCreator.sh $1/$1.GATK.bam.Dedupping.bam $SureSelectINTERVAL # optional args [xxx.intervals]
	GenomeAnalysisTK.IndelRealigner.sh $1/$1.GATK.bam.Dedupping.bam $1/$1.GATK.bam.Dedupping.bam.RealignerTargetCreator.intervals
	FixMateInformation.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam
	GenomeAnalysisTK.CountCovariates.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam
	GenomeAnalysisTK.TableRecalibration.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.recal_data.csv
	AnalyzeCovariates.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.recal_data.csv $1/original.bam

	samtools sort $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted
	samtools index $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam
	GenomeAnalysisTK.CountCovariates.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam

	AnalyzeCovariates.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam.recal_data.csv $1/recal.bam
	
	## indel calling
	GenomeAnalysisTK.IndelGenotyperV2 $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam

	## SNP calling
	GenomeAnalysisTK.UnifiedGenotyper $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam
	
	## Variant quality score recalibration. only SNP
	## step 3
	# 1.	GenerateVariantClusters 
	# 2.	VariantRecalibration
	# 3.	ApplyVariantCuts

	## 1.
	GenomeAnalysisTK.GenerateVariantClusters.sh $1/$1.GATK.bam.Dedupping.bam.IndelRealigner.bam.FixMateInformation.bam.TableRecalibration.bam.sorted.bam.snp.raw.vcf

	## 2.

	## 3.


	#mkdir -p $1/{log,pdf,gz,summary,bam}
	#mv $1/*.log $1/log
	#mv $1/*.pdf $1/pdf
	#mv $1/*.gz $1/gz
	#mv $1/*.bam $1/bam
	#mv `find $1 -maxdepth 1 | egrep "(Collect|Estimate|MeanQuality|QualityScore|MarkDupli)"` $1/summary
