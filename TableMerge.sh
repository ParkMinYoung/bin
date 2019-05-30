#!/bin/sh

. ~/.bash_function

OUT=$1
shift
FILE=$1
shift

#if [ ! -f "$OUT" ] && [ -f "$FILE" ];then
if [ ! -f "$OUT" ] ;then
	(cat $FILE;   for i in $@; do sed -n '2,$'p $i;done)  > $OUT
else
	usage "OUTPUT INPUT1 INPUT2 ...."
fi

