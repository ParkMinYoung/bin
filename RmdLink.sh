#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] && [ -d "$2" ];then

	file=$(readlink -f $1)
	cd $2
	(echo -e "# execute time : "$(date +'%Y-%M-%d %H:%M:%S')" : file link" ; _exe "ln -s $file ./"; echo -e "\n\n" ) >> readme

else

	usage "Target_File Target_DIR"

fi


