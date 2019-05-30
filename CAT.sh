#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

     case "$1" in
        *.gz)   zcat $1 ;;
        *.bz2)  bzcat -c $1;;
        *)      cat $1;;
 
     esac
else
	usage "txt|fastq|gz|bz2"
fi

