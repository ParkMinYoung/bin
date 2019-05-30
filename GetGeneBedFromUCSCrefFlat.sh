#!/bin/sh

. ~/.bash_function

if [ -f "$1" ]; then

		refFlat2UniqGene.sh $1

elif [ ! -f "refFlat.txt" ];then
	
		refFlat.down.sh
		echo "$0 refFlat.txt"

else

		usage "refFlat"

fi

