#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then


	cd /home/adminrig/src/phlat-1.0/dist/uncompyle2-master 
	bin/uncompyle2 --py -o . $1

else	
	
	usage "XXX.pyo"

fi



