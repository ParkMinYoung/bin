#!/bin/sh

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -eq 3 ]
then

REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
FILEDIR=`dirname $1`


# align
# -l : seed len
# -k : mismatch in seed len
bwa aln -I -l $2 -k $3 $REF $1 > $1.sai

# create sai
#bwa samse $REF $1.ReadFilter.sanger.fastq.sai $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
#bwa sampe $REF $1.1.ReadFilter.sanger.fastq.sai $1.2.ReadFilter.sanger.fastq.sai $1.1.ReadFilter.sanger.fastq $1.2.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
bwa samse $REF $1.sai $1 | gzip > $1.sam.gz

# convert from sam to bam
#samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam

# sort
#samtools sort $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

# covert SAM to BAM and perform sorting
samtools view -uS -q 30 $1.sam.gz | samtools sort - $1.bam.sorted

else
    usage [fastq1] [fastq2] [seed len] [mismatch num in the seed]
fi



