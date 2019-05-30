#!/bin/sh 

. ~/.bash_function
if [ -f "$1" ];then

	head -1000 $1 | grep ^#CHRO | cut -f10- |  tr "\t" "\n"
else
	usage "XXX.vcf"
fi

