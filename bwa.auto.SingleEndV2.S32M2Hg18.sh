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


REF=/home/adminrig/Genome/maq_hq18/hg18.fasta
CWD=`pwd`
FILEDIR=`dirname $1`

# ReadFilter.sh $1 $2
# covert ill2sanger format
#perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1 > $1.ReadDist
ln -s $CWD/$1 $CWD/$1.ReadFilter
#maq ill2sanger $1.ReadFilter $1.ReadFilter.sanger.fastq

# align
# -l : seed len
# -k : mismatch in seed len
bwa aln -I -l $2 -k $3 $REF $1 > $1.ReadFilter.sanger.fastq.sai

# create sai
# bwa samse $REF $1.ReadFilter.sanger.fastq.sai $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
bwa samse $REF $1.ReadFilter.sanger.fastq.sai $1 | gzip > $1.ReadFilter.sanger.fastq.sai.sam.gz

# convert from sam to bam
# samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam

# sort
# samtools sort $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

# covert SAM to BAM and perfrom sorting
samtools view -uS $1.ReadFilter.sanger.fastq.sai.sam.gz | samtools sort - $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

