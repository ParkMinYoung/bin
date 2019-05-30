#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	grep -w -e MonoHighResolution -e NoMinorHom -e PolyHighResolution $1 | cut -f1 | grep -v ^AFFX 

else
	
	usage "Ps.performance.txt"

fi


