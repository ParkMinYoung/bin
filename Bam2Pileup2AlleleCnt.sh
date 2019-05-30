#!/bin/sh -x


source $HOME/.bash_function

if [ $# -ne 1 ]
then
    usage [s_?]
fi



#REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
REF=/home/adminrig/src/GATK/GATK.data/b37/Sequence/human_g1k_v37.fasta.ShortID
TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed

SAMTOOLS=/home/adminrig/src/SAMTOOLS/samtools-0.1.16/samtools

$SAMTOOLS pileup -c -2 -f $REF $1 > $1.pileup
PileupParsing.noTarget.pl --in-file $1.pileup --target-file $TILE --quality-score 0 --out-file $1.pileup.AlleleCnt

