#!/bin/sh

source ~/.bash_function

EXT=$(perl -sle'$f=~/\.?(\w+)?$/;print $1' -- -f=$1)

if [ $EXT == "gz" ];then
#-phred64 				\
		zcat $1 | 				\
		prinseq-lite.pl 		\
		-fastq stdin			\
		-graph_data $1.out_good.fastq.gd	\
		-out_good good 			\
		-out_bad null 			\
		-log $1.prinseq.log 	\
		-out_format 3			\
		-out_good $1.out_good	\
		-out_bad null			\
		-exact_only				\
		-min_len 50				\
		-min_qual_mean 18		\
		-ns_max_p 10			\
		-derep 14				\
		-trim_left 11			\
		-trim_right 5			\
		-min_gc 10				\
		-trim_qual_left 10		\
		-trim_qual_right 10		\
		-trim_tail_right 20		\
		-trim_tail_left 20		
else
#-phred64 				\
		prinseq-lite.pl 		\
		-fastq $1				\
		-graph_data $1.out_good.fastq.gd	\
		-out_good good 			\
		-out_bad null 			\
		-log $1.prinseq.log 	\
		-out_format 3			\
		-out_good $1.out_good	\
		-out_bad null			\
		-exact_only				\
		-min_len 50				\
		-min_qual_mean 18		\
		-ns_max_p 10			\
		-derep 14				\
		-trim_left 11			\
		-trim_right 5			\
		-min_gc 10				\
		-trim_qual_left 10		\
		-trim_qual_right 10		\
		-trim_tail_right 20		\
		-trim_tail_left 20		
fi

mkdir $1.prinseq

prinseq-graphs.pl -i $1.out_good.fastq.gd -png_all -o $1.prinseq/png
prinseq-graphs.pl -i $1.out_good.fastq.gd -html_all -o $1.prinseq/html



prinseq-lite.pl -fastq $1.out_good.fastq -graph_data $1.out_good.fastq.gd -out_good null -out_bad null -phred64 -log $1.out_good.fastq.log
mkdir $1.out_good.fastq.prinseq
 
prinseq-graphs.pl -i $1.out_good.fastq.gd -png_all -o $1.out_good.fastq.prinseq/png
prinseq-graphs.pl -i $1.out_good.fastq.gd -html_all -o $1.out_good.fastq.prinseq/html
		  ~                                                                                         

#mkdir $1.prinseq

#prinseq-graphs.pl -i $1.gd -png_all -o $1.prinseq/png
#prinseq-graphs.pl -i $1.gd -html_all -o $1.prinseq/html
