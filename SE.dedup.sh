#!/bin/sh
source ~/.bash_function

if [ -f "$1" ] ;then
FILE1=$1

sed -n '2~4p' $FILE1 | \
perl -F'\t' -anle'$str=substr($F[0], 0, 50);
$h{$str}++ }{ 
map{print "$_\t$h{$_}" if $h{$_}>1} keys %h' > $FILE1.SE.dedup

else 
	usage "fastq1"
fi
