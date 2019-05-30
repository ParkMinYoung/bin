#!/bin/bash

. ~/.bash_function

if [ $# -eq 1 ];then

	find -type f | grep readme$ > readme.list

	echo -e `date` "readme file searching....\n\n" 

	xargs -a readme.list grep -i $1 readme.list.outputs

else

	usage "pattern_string"

fi



