#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] && [ $# -eq 3 ];then

	perl -F'\t' -MMin -asne'chomp@F; $h{$F[$col1-1]}{$F[$col2-1]}++ }{ mmfss("Table", %h)' -- -col1=$2 -col2=$3 $1
else
	" XXX 4[column numb] 5[column numb]"
fi

