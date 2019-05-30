#!/bin/sh


#fasta_formatter -i contigs.fa -o contigs.fa.single -w 0
#LINE=$(wc -l contigs.fa.single | perl -nle'/\d+/;print int($&/20)')
#split -l $LINE contigs.fa.single split.

source ~/.bash_function

if [ -f "$1" ] ;then

	FAS=$1
	F_NUM=$2	
	N=${F_NUM:=20}
	
	mkdir Fasta.Divde

	fasta_formatter -i $FAS -o $FAS.single -w 0
	LINE=$(wc -l $FAS.single | perl -snle'/\d+/;print int($&/$N+1)' -- -N=$N)
	split -l $LINE $FAS.single Fasta.Divde/$FAS.split.
else
	usage "XXX.fasta [20(file number)]"
fi


