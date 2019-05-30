#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ];then

	cut -f$2 $1  | sort | uniq -d  | grep -f - $1 | sort -k$2,$2
else
	usage "File Column"
fi


