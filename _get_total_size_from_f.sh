#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then
	cat $1 | xargs du -ch | tail -n1 | awk '{print $1}'
else
	usage "file_including_filelist"
fi
