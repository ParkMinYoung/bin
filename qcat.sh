#!/bin/sh 
. ~/.bash_function

OUT=$1
shift

if [ $# -gt 2 ] & [ -f "$1" ] & [ -f "$2" ];then

	cat $@ > $OUT

else
	usage "output_file in1 in2 ...."
fi

