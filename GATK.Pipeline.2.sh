#!/bin/sh 


#$1=s_2/s_2.1.fastq
#$2=s_2/s_2.2.fastq
#$3=ReadGroup

source ~/.bash_function

if [ $# -ge 3 ]; then

	R1=$1
	R2=$2
	RG=$3
	Tread=$4
	# align
	GATK.Trim2Bwa.sh $R1 $R2 $Tread>& GATK.Trim2Bwa.sh.$RG.log
	#GATK.Trim2Bwa.sh $R1 $R2 2 >& GATK.Trim2Bwa.sh.$RG.log

	# sorting 
	#MergeSamFiles.sh s_2/s_2.1.fastq.bam 
	# no need ReadGroup 
	#MergeSamFiles.sh $R1.bam 
	SortSam.sh $R1.bam 

	# indexing
	# no need ReadGroup 
	# BuildBamIndex.sh $R1.bam.sorted.bam

	# insert 
	# AddOrReplaceReadGroups.sh XXX.bam ReadGroup
	# bwa sampe -r @RG\tID:Cellularity\tSM:paired
	AddOrReplaceReadGroups.sh $R1.bam.sorted.bam $RG
	# output $R1.bam.sorted.bam.AddRG.bam
	
	#################################
	## Quality Score Recalibration ##
	#################################
	
	### original bam ###

	# CountCovariates ( create csv ) from original 
	# need ReadGroup 
	# GenomeAnalysisTK.CountCovariates.sh XXX.bam [ReadGroup]
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.AddRG.bam

	# Table Recalibration ( create new bam )
	# need ReadGroup 
	GenomeAnalysisTK.TableRecalibration.sh $R1.bam.sorted.bam.AddRG.bam $R1.bam.sorted.bam.AddRG.bam.recal_data.csv 

	### newer bam ###

	# CountCovariates ( create csv ) from newer
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam 

	# AnalyzeCovariates ( create plots ) from original csv
	# no need ReadGroup 
	AnalyzeCovariates.sh $R1.bam.sorted.bam.AddRG.bam.recal_data.csv $R1.bam.sorted.bam.AddRG.bam.recal_data.csv.stat
	 
	# AnalyzeCovariates ( create plots ) from newer csv
	# no need ReadGroup 
	AnalyzeCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.recal_data.csv $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.recal_data.csv.stat 

	##################################
	## realignment for indel region ##
	##################################

	# RealignerTargetCreator ( for new bam )
	# no need ReadGroup 
	GenomeAnalysisTK.RealignerTargetCreator.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam

	# IndelRealigner ()
	# no need ReadGroup 
	GenomeAnalysisTK.IndelRealigner.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.RealignerTargetCreator.intervals

	#################################
	## remove duplicate read pair  ##
	#################################

	# MarkDuplicates ( remove duplicate )
	# no need ReadGroup 
	MarkDuplicates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam
	bam2index.flag.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	QualityScoreDistribution.Only.Aligned.PF.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam 
	CollectInsertSizeMetrics.AutoFix.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
	CollectGcBiasMetrics.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
	
	# indexing ( above CREATE_INDEX=true setting )
	# BuildBamIndex.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# CountCovariates ( create csv ) from Deduplicated bam
	# need ReadGroup 
#!@	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# AnalyzeCovariates ( create plots ) from Deduplicated bam
#!@	AnalyzeCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv.stat

	###################################
	## multiple sample genotype call ##
	###################################

	# UnifiedGenotyper
	# no need ReadGroup 
# GenomeAnalysisTK.UnifiedGenotyper $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

else
	usage "R1.fastq R2.fastq ReadGroup(sample name, id)"
fi



