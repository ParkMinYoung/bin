#!/bin/sh

source ~/.bash_function

if [ $# -ge 2 ];then

	DIR=$1
	shift

	for i in $@
		do 
		if [ -f "$i" ];then
			echo "[`date`] checked $i"
		else
			echo "[`date`] unchecked $i"
			FLAG=1
		fi
	done
	
	if [ $FLAG ];then
		echo -e "\n\ncheck system is failed"
		usage "DestinationDir XXX [YYY ZZZ ...]"
	else
		echo -e "\n\ncheck system is passed!"
	fi

	for i in $@;do ln -s $(readlink -f $i) $DIR;done
#for i in $@;do ln $i $DIR;done
		
			
else
	usage "DestinationDir XXX [YYY ZZZ ...]"
fi
