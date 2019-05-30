#!/bin/sh -x


source $HOME/.bash_function

if [ $# -ne 1 ]
then
    usage xxx.bam 
fi




# mapping quality QC 10 and perform sorting
#samtools view -ub -q 10 $1 | samtools sort - $1.Q10.sorted

samtools sort $1 $1.sorted

# indexing bam
samtools index $1.sorted.bam

# Mark Duplicates
MarkDuplicates.sh $1.sorted.bam
