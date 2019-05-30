#!/bin/sh


# samtools pileup 
# -Q min base quality [13]
# -d limit max depth [1204]


# samtools.pl varFilter
# -d min depth
# -D limit max depth [1204]
# -Q RMS mapping quality >=25
# -S snp quality score >= 25

# Filtering and final list generation
# A simple awk script can be used to filter our list of variations where the indel SNP quality is greater than 50 or 60 respectively:
# awk '($3=="*"&&$6>=50)||($3!="*"&&$6>30)' variations.list > variations.filtered.list

# Exporting to other formats
# The samtools distribution contains a helper script called sam2vcf.pl that may be used to convert to the Variant Call Format? (VCF (external link)):
# sam2vcf.pl  variations.filtered.list -r hg18.fasta > variations.vcf


source ~/.bash_function

if [ $# -eq 1 ] && [ -f $1 ];then
	
	REF=~/Genome/hg19.bwa/hg19.fasta

	echo "[`date`] start. sorted.bam file : $1"
	samtools pileup -Q 20 -d 2000 -vcf $REF $1 > $1.variation.pileup
	
	#samtools.pl varFilter -d 10 -D 2000 -Q 25 -S 25 $i.variation.pileup > $i.variation 
	samtools.pl varFilter -d 10 -D 2000 -Q 25 -S 25 $1.variation.pileup | awk '($3=="*"&&$6>=50)||($3!="*"&&$6>30)' | sam2vcf.pl -r $REF > $1.variation.pileup.D20.vcf
	echo "[`date`] end.  : $1.variation.pileup.D20.vcf"
else
	usage XXX.sorted.bam
fi


