#!/bin/sh

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -ne 3 ]
then

    usage [fastq] [seed len] [mismatch num in the seed]
fi

fchk $1

REF=/home/adminrig/Genome/www.arb-silva.de/RibosomeLSSURef_102.fasta
CWD=`pwd`
FILEDIR=`dirname $1`


# Ribo.sh $1 $2
# covert ill2sanger format
perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1 > $1.ReadDist
ln -s $CWD/$1 $CWD/$1.Ribo
maq ill2sanger $1.Ribo $1.Ribo.sanger.fastq

# align
# -l : seed len
# -k : mismatch in seed len
bwa aln -l $2 -k $3 $REF $1.Ribo.sanger.fastq > $1.Ribo.sanger.fastq.sai
#bwa aln -l $2 -k 3 $REF $1.Ribo.sanger.fastq > $1.Ribo.sanger.fastq.sai
#bwa aln -l $2 -k 3 $REF $1.Ribo.sanger.fastq > $1.Ribo.sanger.fastq.sai

# create sai
bwa samse $REF $1.Ribo.sanger.fastq.sai $1.Ribo.sanger.fastq > $1.Ribo.sanger.fastq.sai.sam

# convert from sam to bam
samtools view -bS -o $1.Ribo.sanger.fastq.sai.sam.bam $1.Ribo.sanger.fastq.sai.sam

# sort
samtools sort $1.Ribo.sanger.fastq.sai.sam.bam $1.Ribo.sanger.fastq.sai.sam.bam.sorted

