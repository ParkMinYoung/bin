#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] ;then

	F_default=chr
	FORMAT=${2:-$F_default}

	if [ $# -eq 2 ];then # num format

		# execute time : 2018-12-04 13:36:14 : unique CHR bed
		egrep ^"([0-9]+|X|Y|M)" $1 | cut -f 1-3 | sed 's/^/chr/' | bedtools sort -i stdin | bedtools merge -i stdin | bedtools sort -i stdin > $1.CHR.bed 
	
	else				 # chr format
		
		# execute time : 2018-12-04 13:36:14 : unique CHR bed
		egrep ^"(chr)" $1 | cut -f 1-3 | bedtools sort -i stdin | bedtools merge -i stdin | bedtools sort -i stdin > $1.CHR.bed 
	
	fi


	# execute time : 2018-12-04 13:37:25 : unique NUM bed
	sed 's/^chr//' $1.CHR.bed > $1.NUM.bed


	# execute time : 2018-12-04 13:39:57 : make intervals
	bed2intervals $1 

else

	usage "XXX.bed [num] "

fi
