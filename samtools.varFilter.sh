#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
	REF=~/Genome/hg19.bwa/hg19.fasta
	samtools.pl varFilter -d 20 -D 2000 -Q 25 -S 25 $1 | awk '($3=="*"&&$6>=50)||($3!="*"&&$6>30)' | sam2vcf.pl -r $REF > $1.D20.vcf
else
	echo "find -type f | grep variation.pileup$ | xargs -i echo ./samtools.varFilter.sh {} | sh"
	echo "find -type f | grep D20.vcf$ | xargs -i echo vcf.pipeline.sh {} | sh"
	usage try.variation.pileup
fi

