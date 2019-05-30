#!/bin/sh

source ~/.bash_function

if [ $# -gt 2 ];then
	Col=$1
	shift
	for i in $@;do echo -ne "$i\t" && ColSum.sh $Col $i;done
else
	usage "Column_int file list"
fi

