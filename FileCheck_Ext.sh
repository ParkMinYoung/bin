#!/bin/bash

. ~/.bash_function

if [ $# -ge 3 ] && [ -f "$3" ];then

	ExistExt=$1
	CheckExt=$2
	shift
	shift

	for i in $@
		do file=${i%.$ExistExt}
		[ ! -f "$file.$CheckExt" ] && echo $i
	done 

else	
	echo "FileCheck_Ext.sh sam csv *.sam"
	usage "Exist_Extension Check_Extension Files"

fi



