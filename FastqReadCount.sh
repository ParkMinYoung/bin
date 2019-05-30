#!/bin/sh

source ~/.bash_function


if [ -f "$1" ];then

	date >> FastqReadCount

	for i in $@
		do 

		EXT=$(perl -sle'$f=~/\.?(\w+)?$/;print $1' -- -f=$i)
		
		if [ $EXT == "gz" ];then
			#READ=$(zcat $i | grep -c "^+$")
			READ=$(zcat $i | egrep -c "^\+((HWI-ST|HWUSI|ILL).+|$)")
		else
			#READ=$(grep -c "^+$" $i)
			READ=$(egrep -c "^\+((HWI-ST|HWUSI|ILL).+|$)" $i)
		fi
		
		
		echo -ne "$READ\t$i\n" >> FastqReadCount
		#grep -c "^@" $@ >> FastqReadCount

		done
else
	usage "XXX.fastq{.gz} YYY.fastq{.gz} ..."
fi
