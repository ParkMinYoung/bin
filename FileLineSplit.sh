#!/bin/bash

. ~/.bash_function

if [ $# -ge 3 ];then

#	FILE=$1
#	HEADER_LINE=$2
#   PerLINE=$3





head -n $2 $1 > header
sed -n "$(( $2 + 1 )),$"p $1 > content
	#split -l $(( 632 * 100 )) content
#split -l $3 -d -a 2 content 


	if [ $# -eq 4 ];then
		split -l $3 -d -a 2 content 
	else
		split -l $3 content 
	fi

		
for i in  x??; do cat header $i > $1.$i; done 

rm -rf x?? header content


else	
	usage "FILE HEADER_LINE[1] PerLINE[100] [Num]"
fi

