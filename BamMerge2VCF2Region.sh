#!/bin/sh

source ~/.bash_function


# $1=output_dir
# $2=output.bam




if [ -f "$3" ];then

	DIR=$1
	shift
	OUT=$1
	shift
	
	if [ ! -d $DIR ];then
		mkdir $DIR
	fi

	echo $@
	samtools merge $DIR/$OUT.bam $@
	samtools sort $DIR/$OUT.bam $DIR/$OUT.bam.sort
	samtools index $DIR/$OUT.bam.sort.bam
	Pileup2VariationPileup.sh $DIR/$OUT.bam.sort.bam
	vcf.pipeline.sh $DIR/$OUT.bam.sort.bam.variation.pileup.D20.vcf 

else
	usage "out_dir merged_bam_name bam1 bam2 ..."
fi
