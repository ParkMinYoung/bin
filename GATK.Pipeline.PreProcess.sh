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
	GATK.Trim2Bwa.sh $R1 $R2 >& GATK.Trim2Bwa.sh.$RG.log

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
	AddOrReplaceReadGroups.sh $R1.bam.sorted.bam $RG
	# output $R1.bam.sorted.bam.AddRG.bam

else
	usage "R1.fastq R2.fastq ReadGroup(sample name, id)"
fi

