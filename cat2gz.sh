#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then
#if [ $# -eq 2 ] && [ -f "$1" ];then
	IN=$1
	#OUT=$2
	OUT=$IN.gz
	#echo "$IN $OUT"
	cat $IN | gzip - > $OUT
else
	usage "xxx output.gz"
fi

