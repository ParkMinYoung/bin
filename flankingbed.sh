#!/bin/sh

source ~/.bash_function

if [ -f "$1" ]; then

	FILE=$1

	DEFAULT=300
	len=$2
	LEN=${len:=$DEFAULT}

	FASTA=/home/adminrig/Genome/dbSNP/Mask/hg19.subst.fasta
	GENOME=/home/adminrig/Genome/dbSNP/Mask/hg19.genome


	slopBed -i $FILE -b $LEN -g $GENOME > $FILE.$LEN.bed
	$(fastaFromBed -fi $FASTA -bed $FILE.$LEN.bed -fo $FILE.$LEN.bed.fasta -tab)

else
	
#FILEDIR=$(fullpath hg19.genome)
#echo $FILEDIR
	usage "bed [Flanking seq length : 250]"
fi

