#!/bin/sh


. ~/.GATKrc
. ~/.bash_function

REFSNP=/home/adminrig/Genome/dbSNP/Mask/hg19.subst.fasta

if [ -f "$1" ];then
	
	fastaFromBed -fi $REFSNP -bed $1 -fo $1.iupac.seq -tab
	fastaFromBed -fi $UCSChg19 -bed $1 -fo $1.seq -tab

	paste $1.iupac.seq $1.seq  | perl -F'\t' -anle'$F[0]=~/(chr\w+):\d+-(\d+)/;print join "\t", $1,$2,$F[3],$F[1]' > $1.SNP
else
	usage "Target.bed"

fi



