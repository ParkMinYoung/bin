#!/bin/sh -x


source $HOME/.bash_function

if [ $# -ne 1 ]
then
    usage [s_?]
fi



REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed

# mapping quality QC 10 and perform sorting
#samtools view -ub -q 10 $1 | samtools sort - $1.Q10.sorted

samtools sort $1 $1.Q0.sorted

# indexing bam
samtools index $1.Q0.sorted.bam


samtools pileup -c -2 -f $REF $1.Q0.sorted.bam > $1.Q0.sorted.bam.pileup
PileupParsing.noTarget.pl --in-file $1.Q0.sorted.bam.pileup --target-file $TILE --quality-score 34 --out-file $1.Q0.sorted.bam.pileup.AlleleCnt

