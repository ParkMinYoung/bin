#!/bin/sh

. ~/.bash_function
#perl -F'\t' -MMin -anle'push @meth, $F[3] if $F[4]+$F[5]>=10 }{ histogram_tab(5, @meth)' $1 > $1.histogram
#grep -v ^# AxiomGT1.report.txt | cut -f3  | perl -F'\t' -MMin -anle'push @meth, $_ }{ histogram_tab(1, @meth)'

if [ $# -eq 2 ];then
	cut -f$2 $1 | perl -F'\t' -MMin -anle'push @meth, $_ }{ histogram_tab(1, @meth)'
else
	usage "file column_Num"
fi

