#!/bin/sh

source ~/.bash_function

if [ $# -ge 2 ];then

	OUTPUT=$1
	shift

	perl -F'\t' -MMin -asne'chomp@F;$h{$F[0]}{$ARGV}=$F[1]}{mmfsn($out,%h)' -- -out=$OUTPUT $@

else
	usage "OutputName xxx.txt yyy.txt ...."
fi


