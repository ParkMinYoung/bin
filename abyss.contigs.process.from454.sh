
#!/bin/sh

if [ -f "$1" ];then

	IN=$1
	abyss.contig.fa.overlen.sh $IN 100 
	fasta.overlap.split.sh $IN.over100.fa > $IN.over100.fa.500-300.fa
	perl -nle'if(!/^>/){tr/RYMKWSBDHVN/ACAGACCAAAA/}print' $IN.over100.fa.500-300.fa > $IN.over100.fa.500-300.fa.Modify.fa

else
	usage "abyss.contigs.fa"
fi

