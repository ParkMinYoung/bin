#!/bin/sh 


#$1=s_2/s_2.1.fastq
#$2=s_2/s_2.2.fastq
#$3=ReadGroup

source ~/.bash_function

if [ $# -eq 3 ]; then

	R1=$1
	R2=$2
	RG=$3

	# align
	GATK.Trim2Bwa.sh $R1 $2 >& GATK.Trim2Bwa.sh.$RG.log

	# sorting 
	#MergeSamFiles.sh s_2/s_2.1.fastq.bam 
	# no need ReadGroup 
	MergeSamFiles.sh $R1.bam 

	# indexing
	# no need ReadGroup 
	BuildBamIndex.sh $R1.bam.sorted.bam

	# insert 
	# AddOrReplaceReadGroups.sh XXX.bam ReadGroup
	AddOrReplaceReadGroups.sh $R1.bam.sorted.bam $RG
	# output $R1.bam.sorted.bam.AddRG.bam
	
	# CountCovariates ( create csv ) from original 
	# need ReadGroup 
	# GenomeAnalysisTK.CountCovariates.sh XXX.bam [ReadGroup]
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam 

	# Table Recalibration ( create new bam )
	GenomeAnalysisTK.TableRecalibration.sh $R1.bam.sorted.bam $R1.bam.sorted.bam.recal_data.csv 

	# CountCovariates ( create csv ) from newer
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.TableRecalibration.bam 

	# AnalyzeCovariates ( create plots ) from original csv
	AnalyzeCovariates.sh $R1.bam.sorted.bam.recal_data.csv $R1.bam.sorted.bam.recal_data.csv.stat
	 
	# AnalyzeCovariates ( create plots ) from newer csv
	AnalyzeCovariates.sh $R1.bam.sorted.bam.TableRecalibration.bam.recal_data.csv $R1.bam.sorted.bam.TableRecalibration.bam.recal_data.csv.stat 

	# RealignerTargetCreator ( for new bam )
	GenomeAnalysisTK.RealignerTargetCreator.sh $R1.bam.sorted.bam.TableRecalibration.bam

	# IndelRealigner ()
	GenomeAnalysisTK.IndelRealigner.sh $R1.bam.sorted.bam.TableRecalibration.bam $R1.bam.sorted.bam.TableRecalibration.bam.RealignerTargetCreator.intervals

	# MarkDuplicates ( remove duplicate )
	MarkDuplicates.sh $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam

	# indexing ( above CREATE_INDEX=true setting )
	# BuildBamIndex.sh $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# CountCovariates ( create csv ) from Deduplicated bam
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# AnalyzeCovariates ( create plots ) from Deduplicated bam
	AnalyzeCovariates.sh $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv.stat

	# Add Read Group
	AddOrReplaceReadGroups.sh $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
	# less $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.AddRG.bam.log

	# UnifiedGenotyper
	GenomeAnalysisTK.UnifiedGenotyper $R1.bam.sorted.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.AddRG.bam

else
	usage "R1.fastq R2.fastq s_1"
fi

