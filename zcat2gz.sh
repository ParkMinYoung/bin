#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ];then
	IN=$1
	OUT=$2
	#echo "$IN $OUT"
	zcat $IN | gzip - > $OUT
else
	usage "xxx.gz output.gz"
fi

