#!/bin/sh

. ~/.bash_function

if [ $# -gt 2 ] & [ -f "$2" ];then

	perl -F'\t' -MMin -aslne'
	chomp@F;
	$h{$F[$col-1]}++;
	}{ v1np(%h)' -- -col=$1 $2
	

else
	usage "Col_Num Files"
fi


