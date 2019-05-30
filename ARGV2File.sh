#!/bin/sh

. ~/.bashrc

if [ $# -ge 3 ];then

	PID=$1
	shift
	FILE=$2
	shift

	echo $@ | tr " " "\n" > log.`date +%Y%m%d`.$PID
else
	usage "PID File_name ARGVs"
fi


