#!/bin/sh

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -ne 3 ]
then

    usage [fastq] [seed len] [mismatch num in the seed]
fi

fchk $1.1
fchk $1.2


REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
FILEDIR=`dirname $1`

# ReadFilter.sh $1 $2
# covert ill2sanger format

#perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1.1 > $1.1.ReadDist
#perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1.2 > $1.2.ReadDist

#ln -s $1.1 $1.1.ReadFilter
#ln -s $1.2 $1.2.ReadFilter
ls $1.{1,2} | perl -nle'$_="$ENV{PWD}/$_"; `ln -s $_ $_.ReadFilter`'

## modify ##

#maq ill2sanger $1.1.ReadFilter $1.1.ReadFilter.sanger.fastq
#maq ill2sanger $1.2.ReadFilter $1.2.ReadFilter.sanger.fastq

## modify ##







# align
# -l : seed len
# -k : mismatch in seed len
bwa aln -I -l $2 -k $3 $REF $1.1 > $1.1.ReadFilter.sanger.fastq.sai
bwa aln -I -l $2 -k $3 $REF $1.2 > $1.2.ReadFilter.sanger.fastq.sai

# create sai
#bwa samse $REF $1.ReadFilter.sanger.fastq.sai $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
#bwa sampe $REF $1.1.ReadFilter.sanger.fastq.sai $1.2.ReadFilter.sanger.fastq.sai $1.1.ReadFilter.sanger.fastq $1.2.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
bwa sampe $REF $1.1.ReadFilter.sanger.fastq.sai $1.2.ReadFilter.sanger.fastq.sai $1.1 $1.2 | gzip > $1.ReadFilter.sanger.fastq.sai.sam.gz

# convert from sam to bam
#samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam

# sort
#samtools sort $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

# covert SAM to BAM and perform sorting
#samtools view -uS $1.ReadFilter.sanger.fastq.sai.sam.gz | samtools sort - $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.gz
Bam2MappingQ102Sort2Pileup2AlleleCnt.sh $1.ReadFilter.sanger.fastq.sai.sam.bam


