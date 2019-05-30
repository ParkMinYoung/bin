#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then
T=${Thread:=4}
S=${SeedLen:=32}
M=${MisMatch:=2}
REF=/home/adminrig/Genome/BOWTIE_INDEX/BOWTIE.Genome/Homo_sapiens/genome.fa

perl -F'\t' -anle'if($F[0] eq "MT"){$F[0]="chrM"}elsif(length($F[0])<=2){$F[0]="chr$F[0]"} print join "\t", "$F[0]",@F[1..$#F]' /home/adminrig/Genome/GTF/Homo_sapiens.GRCh37.69.gtf.bed > Homo_sapiens.GRCh37.69.gtf.bed
GTFBED=$PWD/Homo_sapiens.GRCh37.69.gtf.bed


#cutadapt -m 16 -b GGCCAAGGCG -o $1.cutadaptTrim.fastq $1 > $1.log

bwa aln -t $T -l $S -k $M $REF $1.cutadaptTrim.fastq > $1.cutadaptTrim.fastq.sai 2> $1.cutadaptTrim.fastq.sai.log

bwa samse $REF $1.cutadaptTrim.fastq.sai $1.cutadaptTrim.fastq | gzip > $1.cutadaptTrim.fastq.sam.gz 2> $1.cutadaptTrim.fastq.sam.gz.log 

# covert SAM to BAM and perfrom sorting
samtools view -uS $1.cutadaptTrim.fastq.sam.gz | samtools sort - $1.cutadaptTrim.fastq

bam2index.flag.sh $1.cutadaptTrim.fastq.bam

mRNA.region.intersect.sh  $1.cutadaptTrim.fastq.bam $GTFBED
mRNA.region.count.sh `find -type f | grep miRNA$`


else
	usage "XXX.fastq"
fi

