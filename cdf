#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then
	echo "cd `dirname $1`"
else
	usage "filename"
fi

