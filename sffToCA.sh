#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

	perl -F'\t' -anle'/(\w+?)\.sff/;print "sffToCA -libraryname $1 -insertsize $F[1] $F[2] -linker titanium -trim chop -output $1.frg $F[0] >& $1.frg.log"'  454.pairDist.1200.txt > 454.pairDist.1200.txt.batch.sh
else
	usage "file[/absolute/path/XXX.sff insertSize insertSizeDev]"
fi
