#!/bin/sh

source ~/.bash_function

if [ $# -eq 2 ] & [ -f "$2" ] ;then
	perl -i.bak -sple's/-N\s+(.+?) /-N $job /' -- -job=$1 $2  
else
	usage "job_name sge.script"
fi



