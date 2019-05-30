#!/bin/sh -x


source $HOME/.bash_function

if [ $# -eq 1 ] && [ -f "$1" ]
then

	REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
	TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed

	samtools pileup -c -2 -l var.region -f $REF $1 > $1.pileup
	PileupParsing.noTarget.pl --in-file $1.pileup --target-file $TILE --quality-score 20 --out-file $1.pileup.AlleleCnt

else
    usage XXX.bam 
fi



