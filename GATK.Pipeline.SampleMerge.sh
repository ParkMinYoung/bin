#!/bin/sh 

source ~/.bash_function


		
if [ $# -ge 0 ]; then

	R1=$1
	shift

	for i in $@
	    do
		if [ ! -f "$i" ];then
		    echo -ne `date` "$i do not exist\n"
		fi
	done


	# MergeSamFiles.Multiple.sh output.name x.bam y.bam z.bam ...
	# output : output.name.SortedMerge.bam
	#!# MergeSamFiles.Multiple.sh $R1 $@ 

	ln -s $PWD/$R1.SortedMerge.bam $R1.bam.sorted.bam.AddRG.bam
	ln -s $PWD/$R1.SortedMerge.bai $R1.bam.sorted.bam.AddRG.bai

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

	# indexing ( above CREATE_INDEX=true setting )
	# BuildBamIndex.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# CountCovariates ( create csv ) from Deduplicated bam
	# need ReadGroup 
	GenomeAnalysisTK.CountCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

	# AnalyzeCovariates ( create plots ) from Deduplicated bam
	AnalyzeCovariates.sh $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam.recal_data.csv.stat

	###################################
	## multiple sample genotype call ##
	###################################

	# UnifiedGenotyper
	# no need ReadGroup 
	#!# GenomeAnalysisTK.UnifiedGenotyper $R1.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam

else
	usage "R1.fastq R2.fastq ReadGroup(sample name, id)"
fi

