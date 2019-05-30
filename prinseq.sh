#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

		EXT=$(perl -sle'$f=~/\.?(\w+)?$/;print $1' -- -f=$1)
		 
		if [ $EXT == "gz" ];then
			zcat $1 | prinseq-lite.pl -fastq stdin -graph_data $1.gd -out_good null -out_bad null -phred64 -log $1.prinseq.log 
		else
			prinseq-lite.pl -fastq $1 -graph_data $1.gd -out_good null -out_bad null -phred64 -log $1.prinseq.log 
		fi
		 
		mkdir $1.prinseq

		prinseq-graphs.pl -i $1.gd -png_all -o $1.prinseq/png
		prinseq-graphs.pl -i $1.gd -html_all -o $1.prinseq/html
else
	usage "read.fastq[.gz]"
fi
