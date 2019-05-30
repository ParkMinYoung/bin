#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	for i in $@;do contig.len.sh $i;done
	perl -F'\t' -MMin -ane'chomp(@F);$h{$F[0]}{$ARGV}=$F[1] }{ mmfss("contig.len.dist",%h)' `find -type f | grep len$`
else
	usage "*.fa"
fi

