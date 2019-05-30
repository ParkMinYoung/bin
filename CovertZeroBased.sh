#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

	skip_default=1
	SKIP_LINES=${2:-$skip_default}

	perl -F'\t' -asnle'if($.<=$NumOfLines){print}else{--$F[1];print join "\t", @F}' -- -NumOfLines=$SKIP_LINES $1 > $1.0-based 

else
	
	usage "XXX.table(like bed format) [header lines(1)] : XXX.table.0-based"
fi


 
