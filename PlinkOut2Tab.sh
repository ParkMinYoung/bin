#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then
	perl -nle's/^\s+//; @F=split /\s+/, $_; print join "\t", @F' $1 > $1.tab

else
	usage "plink_output"
fi


