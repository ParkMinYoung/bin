#!/bin/sh -x


source $HOME/.bash_function

IN=$1

if [ -f $IN ];then

	PWD=$PWD
	FILEDIR=`dirname $IN`
	OUTDIR=$PWD/$FILEDIR
	IN=$(echo $IN | sed s/\.bam$//)

	REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
	TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed
	#TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed
	GENOME=/home/adminrig/Genome/hg19Fasta/hg19.genome

	# mapping quality QC 10 and perform sorting
	#!# samtools view -ub -q 10 $IN.bam | samtools sort - $IN.bam.sorted

	# sort bam
	#samtools sort $IN $IN.sorted

	# indexing bam
	# samtools index $IN.sorted.bam

	#!# bamToBed -i $IN.bam.sorted.bam -split | cut -f1-3 > $IN.bam.sorted.bam.read.map
	intersectBed -abam $IN.bam.sorted.bam -b $IN.Target.bed.SeqRegion -bed -split > $IN.bam.sorted.bam.read.map.ExactlyIn

	## Inserted 20101126 ##
	# mapping quality QC 0 and perform sorting
	samtools view -ub $IN.bam | samtools sort - $IN.bam.NoMQ.sorted
	# Intersect region
	intersectBed -abam $IN.bam.NoMQ.sorted.bam -b $IN.Target.bed.SeqRegion -bed -split > $IN.bam.NoMQ.sorted.bam.read.map.ExactlyIn

else
    usage try.bam 
fi
