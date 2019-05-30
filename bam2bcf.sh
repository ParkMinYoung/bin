#!/bin/sh

# LANE=$1
# $1={12,23,12345678}

REF=~/Genome/hg19Fasta/hg19.fasta

source ~/.bash_function

if [ $# -ge 1 ];then
	# -Q : base quality
	# -q : mapping quality
	# -d : max depth per sample
	# -u : uncompressed bcf
	# -g : bcf output
	# -C : recommended value for BWA is 50
	# -o : Phred-scaled gap open sequencing error probability. Reducing INT leads to more indel calls [40]
	# -D : output per-sample DP
	# -l FILE : list of positions (format: chr pos) [null]
	
	# modified cmd
	# samtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 50 -r chr22 -l region -ugf $REF $@ | bcftools view -bvcg - > $1.bcf.var.raw
	
	## region format 
	# chr1 1111
	# chr2 1111
	# if there are variation, it will be reported.
	# but not, it will be omitted.
	
	# original cmd
	# samtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 40 -ugf $REF $@ | bcftools view -bvcg - > $1.bcf.var.raw
	samtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 50 -ugf $REF $@ | bcftools view -bvcg - > $1.bcf.var.raw

	# not use -P ILLUMINA option
	# do not get INDEL result
	#samtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 40 -P ILLUMINA  -ugf $REF $@ | bcftools view -bvcg - > $1.bcf.var.raw
	
	
	#bcftools view $1.bcf.var.raw | vcfutils.pl varFilter -d 10 -D 5000 |  bcf-fix.pl > $1.bcf.var.raw.vcf 
	bcftools view $1.bcf.var.raw | vcfutils.pl varFilter -d 10 -D 5000  > $1.bcf.var.raw.vcf 
	# bcftools view
	# -c : SNP calling
	# -b : output BCF instead of VCF
	# -v : output potential variant sites only (force -c)
	# -g : call genotypes at variant sites (force -c)
	
	# bcftools view
    # -d : minimum read depth [2]
	# -D : maximum read depth [10000]
	
	rm -rf $1.bcf.var.raw.vcf.gz $1.bcf.var.raw.vcf.gz.tbi

	bgzip $1.bcf.var.raw.vcf
	tabix -p vcf $1.bcf.var.raw.vcf.gz

else
	usage xxx.bam [yyy.bam zzz.bam....]
fi
