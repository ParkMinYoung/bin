#!/bin/sh 

source ~/.bash_function

# 1. merge
# 2. duplicate marking
# 3. recalibration
# 4. Realignment
		
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
	# output : $R1.SortedMerge.bam
	MergeSamFiles.Multiple.sh $R1 $@ 

	#################################
	## remove duplicate read pair  ##
	#################################

	# MarkDuplicates ( remove duplicate )
	# no need ReadGroup 
	MarkDuplicates.sh $R1.SortedMerge.bam
	# output : $R1.SortedMerge.bam.Dedupping.bam

	#################################
	## Quality Score Recalibration ##
	#################################
	
	### original bam ###

	# CountCovariates ( create csv ) from original 
	# need ReadGroup 
	# GenomeAnalysisTK.CountCovariates.sh XXX.bam [ReadGroup]
	GenomeAnalysisTK.CountCovariates.sh $R1.SortedMerge.bam.Dedupping.bam

	# Table Recalibration ( create new bam )
	# need ReadGroup 
	GenomeAnalysisTK.TableRecalibration.sh $R1.SortedMerge.bam.Dedupping.bam $R1.SortedMerge.bam.Dedupping.bam.recal_data.csv 

	### newer bam ###

	# CountCovariates ( create csv ) from newer
	GenomeAnalysisTK.CountCovariates.sh $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam 

	# AnalyzeCovariates ( create plots ) from original csv
	# no need ReadGroup 
	AnalyzeCovariates.sh $R1.SortedMerge.bam.Dedupping.bam.recal_data.csv $R1.SortedMerge.bam.Dedupping.bam.recal_data.csv.stat
	 
	# AnalyzeCovariates ( create plots ) from newer csv
	# no need ReadGroup 
	AnalyzeCovariates.sh $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam.recal_data.csv $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam.recal_data.csv.stat 

	##################################
	## realignment for indel region ##
	##################################

	# RealignerTargetCreator ( for new bam )
	# no need ReadGroup 
	GenomeAnalysisTK.RealignerTargetCreator.sh $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam

	# IndelRealigner ()
	# no need ReadGroup 
	GenomeAnalysisTK.IndelRealigner.sh $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam.RealignerTargetCreator.intervals


	###################################
	## multiple sample genotype call ##
	###################################

	# UnifiedGenotyper
	# no need ReadGroup 
	#!# GenomeAnalysisTK.UnifiedGenotyper $R1.SortedMerge.bam.Dedupping.bam.TableRecalibration.bam.IndelRealigner.bam

else
	usage "RG.Name XXX.bam YYY.bam ZZZ.bam ..."
fi

