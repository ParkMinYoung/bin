#!/bin/bash

. ~/.bash_function


if [ -d "$1" ] && [ $# -eq 2 ];then


	cd $1/outs

	tar -cf $2.tar $( ls | grep -v bam )

else

	usage "10x_run_output tar_title"

fi


