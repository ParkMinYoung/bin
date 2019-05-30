#!/bin/bash

. ~/.bash_function

if [ -f $2 ] && [ $# -ge 2 ];then
	
	DIR=$1
	[ ! -d $DIR ] && mkdir -p $DIR
	shift

	for i in $@
		do 
		ln -s $(readlink -f $i) $DIR/$(basename $i)
	done

else	

	usage "Directory Files"

fi


