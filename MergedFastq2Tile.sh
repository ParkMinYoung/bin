#!/bin/sh 
N=`wc -l $1 | perl -nle'print int $_/120'`
csplit -b %03d $1 $N "{118}"  -f $1. > /dev/null 2>&1
ls $1.??? | sort | perl -nle'/(s_\d)\.(\d)/;$c++;$tile=sprintf "%04s", $c;$file=join "_",$1,$2,$tile,"qseq.txt";`mv $_ $file`'

