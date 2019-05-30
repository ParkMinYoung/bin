#!/bin/bash

. ~/.bash_function


#REF=/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta
#BED=/home/adminrig/Genome/SureSelect/Methyl-Seq/SureSelect.MethylSeq.84M.bed

default_REF=/home/adminrig/workspace.min/MethylSeq/Reference/human_g1k_v37.fasta
default_BED=/home/adminrig/Genome/SureSelect/Methyl-Seq/SureSelect.MethylSeq.84M.bed


BAM=$1
REF=${2:-$default_REF}
BED=${3:-$default_BED}
#GENOME=$(basename $REF).genome
GENOME=$REF.genome

if [ -f "$BAM" ] ;then

	MakeBed_Fasta_NTCount.sh $BAM $REF
	bedtools.Coverage.Target_BAM.meanDepth.sh $BED $BAM

	# high load because of memory
	# CountMethylCall_100KbpBin.sh $(dirname $BAM)/*deduplicated.CX_report.txt $REF 

else

	usage "XXX.bam [REF:human_g1k_v37.fasta] [BED:SureSelect.MethylSeq.84M.bed]"

fi


