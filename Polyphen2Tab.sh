#!/bin/sh
. ~/.bash_function


if [ -f "$1" ]; then
	perl -F'\t' -anle'map { s/^\s+//; s/\s+$//; } @F; print join "\t", @F' $1 > $1.tab
	cut -f1-12,15,16,48-50,56 $1.tab > $1.tab.report
	PolyphenReport2Uniq.sh $1.tab.report > $1.tab.report.uniq 
else
	usage "pph2-full.txt"
fi
