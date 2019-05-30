#!/bin/sh

source ~/.bash_funtion

if [ $# -eq 2 ];then

	for i in *.$1 ;do mv ${i%$1}$2; done
else
	usage "gif[original extension] jpg[new extension]"
fi

