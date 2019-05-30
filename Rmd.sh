#!/bin/bash

. ~/.bash_function

WEB=/home/adminrig/workspace.min/DNALink/Project

if [ ! -d "$WEB/$1" ];then
	WEB=$WEB/$1
	mkdir -p $WEB
else
	WEB=$WEB/$1
fi

RMD=($(ls *.Rmd))
# dirlist=(`ls ${prefix}*.text`)		
# http://stackoverflow.com/questions/15224535/bash-put-list-files-into-a-variable-and-but-size-of-array-is-1

if [ -f $RMD ];then

 	
 	for i in ${RMD[@]}; 
 		do 
 		F=${i%.Rmd}
 		echo "make symbolinc link $PWD/$F* $WEB"
		ln -s $PWD/$F.* $WEB
 	done

else
	usage "[Target DIR]"
fi

