#!/bin/bash

. ~/.bash_function

if [ $# -ge 2 ] && [ -d $1 ] ;then

	DIR=$1
	shift

#	set -x 
#STR=$(echo $@ | sed 's/ \+/|/g')
	
	for i in $@
		do
		STR+="| egrep -i $i"
	done

#	set +x

	list=$( eval ls $DIR $STR )
	
	array=($list)
	
	num=0
	for i in $list
		do
		echo -e "$num\t$i"
		((num++))
	done

	read number
	echo select file number : $number

	file=$DIR/${array[$number]}
# _green $(LINE 80)
# _green "show green color text"
# _bold "show blod... text"
# _rev "show rev... text"

 ##	_green $(LINE 80)
 ##	(_bold "selected file :"; _rev "$file")
 ##	less $file

	_H1 blue red "selected file : $file"

	read null

	less $file
else
	echo "$0 vcf plink"
	usage "Target_DIR search pattern list"
fi


