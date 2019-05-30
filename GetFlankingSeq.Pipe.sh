#!/bin/sh

source ~/.bash_function
PERL5LIB=${PERL5LIB}:$HOME/perl/lib/perl5:$HOME/perl/lib/perl5/site_perl/5.8.8:$HOME/perl5/lib/perl5:$HOME/src/vcf-tools/vcftools_0.1.5/perl
export PERL5LIB

if [ -f "$1" ]; then

	perl -i.bak -ple's/\s+//g' $1
	FILE=$(basename $1)
	DIR=$FILE.$(date +%Y%m%d)

	symbol_link $1 $DIR
	cd $DIR
	
	DEFAULT=250
	len=$3
	LEN=${len:=$DEFAULT}

	FASTA=/home/adminrig/Genome/dbSNP/Mask/hg19.subst.fasta
	GENOME=/home/adminrig/Genome/dbSNP/Mask/hg19.genome


	GetFlankingSeq.sh $FILE
	#fastaFromBed -fi hg19.subst.fasta -bed rs.list.20110708.dbsnp.bed -fo rs.list.20110708.dbsnp.bed.fasta -tab
	#slopBed -i rs.list.20110708.dbsnp.bed -b 100 -g hg19.genome
	cut -f2-5 $FILE.dbsnp > $FILE.dbsnp.bed
	slopBed -i $FILE.dbsnp.bed -b $LEN -g $GENOME > $FILE.dbsnp.bed.span$LEN.bed
	$(fastaFromBed -fi $FASTA -bed $FILE.dbsnp.bed.span$LEN.bed -fo $FILE.dbsnp.bed.span$LEN.bed.fasta -tab)
	GetFlankingSeq.Formatting.sh $FILE.dbsnp $FILE.dbsnp.bed.span$LEN.bed.fasta $LEN

else
	
#FILEDIR=$(fullpath hg19.genome)
#echo $FILEDIR
	usage "rs.list.20110708 [Flanking seq length : 250]"
fi

