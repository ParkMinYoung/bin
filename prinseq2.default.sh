#!/bin/sh


zcat $1 | 				\
prinseq-lite.pl 		\
-fastq stdin			\
-out_good good 			\
-out_bad null 			\
-phred64 				\
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



#mkdir $1.prinseq

#prinseq-graphs.pl -i $1.gd -png_all -o $1.prinseq/png
#prinseq-graphs.pl -i $1.gd -html_all -o $1.prinseq/html
