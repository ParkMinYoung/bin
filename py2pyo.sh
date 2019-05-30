#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then
	
	/root/miniconda2/bin/python2.7 -O -m compileall $1 

else
	
	"XXX.py"

fi

