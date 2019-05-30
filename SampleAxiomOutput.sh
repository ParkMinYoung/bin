#!/bin/bash

. ~/.bash_function


if [ $# -ge 2 ];then

		ID=$1
		shift 

		if [ ! -d "$ID" ];then
			mkdir $ID
		fi


		for i in $@
			do
			F=$(readlink -f $i)
			B=$(basename $F)
			
			echo $F;

			if [ $B == "AxiomGT1.summary.txt" ];then
				sed -n "1,/^${ID}-B/p" $F > $ID/$B 
			else
				sed -n "1,/^${ID}/p" $F > $ID/$B 
			fi
		done


else
	usage "AX-106712713 AxiomGT1.* "
fi

