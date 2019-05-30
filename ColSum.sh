#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$2" ];then
	perl -F'\t' -asnle'$s+=$F[$c-1]}{print $s' -- -c=$1 $2
else
	usage "column_int filename"
fi

