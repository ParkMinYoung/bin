#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ];then

R1=$1
R2=$2

export BOWTIE_INDEXE=/home/adminrig/Genome/BOWTIE_INDEX/

# bowtie /home/adminrig/Genome/BOWTIE_INDEX/susScr2 -n 2 -l 28 -e 70 -a -m 1 --phred33-quals -1 $R1_fastq  -2 $R2_fastq  --maxins 5000 --fr --sam $R1_fastq.sam --threads 4 -5 10 -3 10  

bowtie -v 2 -M 10 --best --phred64-quals --maxins 5000 --fr --sam --threads 4 /home/adminrig/Genome/BOWTIE_INDEX/susScr2 -1 $R1 -2 $R2 $R1.sam

gzip $R1.sam
samtools view -uS  $R1.sam.gz | samtools sort - $R1.sorted
bam2index.flag.sh $R1.sorted.bam

samtools rmdup -S $R1.sorted.bam $1.uniq.bam >& $1.uniq.bam.log
bam2index.flag.sh $R1.uniq.bam

else
	usage "R1 R2"
fi

