#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
	IN=$1
	OUT=${1%.gz}
	#echo "$IN $OUT"
	zcat $IN > $OUT
else
	usage "xxx.gz"
fi

