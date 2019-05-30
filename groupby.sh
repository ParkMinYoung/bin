#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] & [ $# -eq 2 ];then 

	datamash -s -H -g $2 count $2 < $1

else	
	usage "Table Column"
fi

