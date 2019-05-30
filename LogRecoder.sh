#!/bin/sh

. ~/.bash_function

if [ $# -ge 2 ];then

	# log file name
	LOG=$1
	shift 

	STR=$(echo $@ | tr " " "\t")

	echo -e "`date "+%F %T"`\t$STR" >> $LOG
else
	usage "log_file_name log_info1 [log_info2 ...]"
fi
