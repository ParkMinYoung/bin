#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ $# -ge 2 ];then


	FILE=$1
	shift
	COL=$1
	shift
	DELIM=${1:-":"}

	perl -F"\t" -MMin -sanle'BEGIN{ @k = args2list($key_col) } $k=join $delim, @F[@k]; print if ! $h{$k}++ ' -- -delim=$DELIM -key_col=$COL $FILE

else
	
	usage "FILE COLUMNs [DELIM]"
fi

